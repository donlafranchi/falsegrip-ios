//
//  SigninVC.swift
//  ExercisesApp
//
//  Created by developer on 9/5/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import AuthenticationServices

class SigninVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - IBAction
    
    @IBAction func didTapAppleSign(_ sender: Any) {
        
        showHUD()
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
}
// MARK: - ASAuthorizationControllerDelegate

extension SigninVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{

    /// Handle failed sign ins
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        dismissHUD()
        print(error.localizedDescription)
    }

    /// Handle successful sign ins
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        dismissHUD()
        
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        UserInfo.shared.setUserInfo(.appleID, value: credentials.user)
        UserInfo.shared.setUserInfo(.email, value: credentials.email ?? "")
         var fullName = ""
        if let name = credentials.fullName {
            if let givenName = name.givenName {
                fullName = givenName
            }
            if let familyName = name.familyName {
                fullName = "\(fullName) \(familyName)"
            }
        }
        UserInfo.shared.setUserInfo(.name, value: fullName)
        
        guard let alertVC = storyboard!.instantiateViewController(withIdentifier: "SignupAlertVC") as? SignupAlertVC else { return }
        alertVC.modalPresentationStyle = .custom
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.delegate = self
        self.present(alertVC, animated: true, completion: nil)
        

    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
    
    
}

extension SigninVC: SignupAlertVCDelegate{
    
    func onSignup(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainNav")
        self.view.window?.rootViewController = vc
    }  
}
