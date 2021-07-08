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
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut(with identifier: String, completion: (URL) -> Void) {
        
    }
    
    
    
    public func uploadVideoURL(from url: URL) {
        
    }
}
