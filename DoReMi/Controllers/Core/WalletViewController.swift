//
//  WalletViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import UIKit

class WalletViewController: UIViewController {
    
    let menuBar: WalletMenuBarView = {
        let menuBar = WalletMenuBarView()
        return menuBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //navigationController?.navigationBar.backgroundColor = .clear
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        setUpMenuBar()
    }
    
    private func setUpMenuBar() {
        view.addSubview(menuBar)
        view.addContraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addContraintsWithFormat("V:|[v0(50)]", views: menuBar)
    }
    
}

extension UIView {
    func addContraintsWithFormat(_ format: String, views: UIView...) {
         var viewDictionary = [String: UIView]()

         for (index, view) in views.enumerated() {
             let key = "v\(index)"
             view.translatesAutoresizingMaskIntoConstraints = false
             viewDictionary[key] = view
         }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDictionary))
     }
}
