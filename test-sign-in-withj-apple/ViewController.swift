//
//  ViewController.swift
//  test-sign-in-withj-apple
//
//  Created by 吉田拓真 on 2020/06/13.
//  Copyright © 2020 hmiyado. All rights reserved.
//

import AuthenticationServices
import UIKit
import Alamofire
//import SwiftJWT

class ViewController: UIViewController {

    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupProviderLoginView()
    }

    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
}

extension ViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension ViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            idLabel.text = "id: " + userIdentifier
            nameLabel.text = "name: " + (fullName?.debugDescription ?? "")
            emailLabel.text = "email: " + (email ?? "")
        
            AF
                .request("https://google.com")
                .response { response in
                    self.logTextView.text = response.description
                }

        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password

            nameLabel.text = "name: " + username
            idLabel.text = "password: " + password

            AF
                .request("https://google.com")
                .response { response in
                    self.logTextView.text = response.description
                }

        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        logTextView.text = error.localizedDescription
    }
}

extension ViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        view.layoutIfNeeded()
    }
}
