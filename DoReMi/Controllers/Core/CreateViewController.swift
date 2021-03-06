//
//  CreateViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import AVFoundation
import UIKit

class CreateViewController: UIViewController {
    
    // Capture Session
    var captureSession = AVCaptureSession()
    
    // Capture Device
    var videoCaptureDevice: AVCaptureDevice?
    
    // Capture Output
    var captureOutput = AVCaptureMovieFileOutput()
    
    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let recordButton = RecordButton()
    
    private var previewLayer: AVPlayerLayer?
    
    var recordedVideoURL: URL?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.backgroundColor = .systemBackground
        setUpCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 85
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size - 5, width: size, height: size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            // stop recording
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()
        }
        else {
            guard var url = FileManager.default.urls(
                    for: .documentDirectory,
                    in: .userDomainMask
            ).first else {
                return
            }
            
            url.appendPathComponent("video.mov")
            
            recordButton.toggle(for: .recording)
            
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(
                to: url,
                recordingDelegate: self
            )
        }
    }
    
    @objc private func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }
        else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }
    
    func setUpCamera() {
        // Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput  = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        
        // update session
        captureSession.sessionPreset = .hd1920x1080
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        // configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        // enable camera start
        
        captureSession.startRunning()
    }

}

extension CreateViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        guard error == nil else {
            let alert = UIAlertController(title: "Whoops",
                                          message: "Something went wrong when recording your video",
                                          preferredStyle: .alert)
            alert.addAction((UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)))
            present(alert, animated: true)
            return
        }
        
        recordedVideoURL = outputFileURL
        
        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        guard let previewLayer = previewLayer else {
            return
        }
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }
    
    @objc func didTapNext() {
        guard let url = recordedVideoURL else {
            return
        }
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController((vc), animated: true)
    }
}
