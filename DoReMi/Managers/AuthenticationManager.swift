//
//  AuthenticationManager.swift
//  DoReMi
//
//  Created by Conor Smith on 7/1/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    public static let shared = AuthManager()
    
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    //Public
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    public func signIn(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func signOut(with identifier: String, completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
    
    
    
    public func uploadVideoURL(from url: URL) {
        
    }
}
