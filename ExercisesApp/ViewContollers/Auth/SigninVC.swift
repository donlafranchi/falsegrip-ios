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

    // MARK: - Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        UserInfo.shared.setUserInfo(.appleID, value: credentials.user)
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
        
//        let params = [
//            "apple_id": UserInfo.shared.appleID] as [String : Any]
        let params = [
            "apple_id": "000376.5a2be77020d842f9ab38727cf99252dc.0240"] as [String : Any]
        ApiService.login(params: params) { (success, data) in
            
            if success {
                print(data!["key"] as! String)
                UserInfo.shared.setUserInfo(.token, value: data!["key"] as! String)
                DispatchQueue.main.async {
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNav")
                    self.view.window?.rootViewController = vc
                }
            }else{
                self.dismissHUD()
                
                if let message = data!["non_field_errors"] as? [String] {
                    guard let alertVC = self.storyboard!.instantiateViewController(withIdentifier: "SignupAlertVC") as? SignupAlertVC else { return }
                    alertVC.modalPresentationStyle = .custom
                    alertVC.modalTransitionStyle = .crossDissolve
                    alertVC.delegate = self
                    self.present(alertVC, animated: true, completion: nil)
                }
                

            }
        }
        

        

    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
    
    
}

extension SigninVC: SignupAlertVCDelegate{
    
    func onSignup(_ name: String){
        showHUD()
        let params = [
            "apple_id": UserInfo.shared.appleID,
            "first_name": name] as [String : Any]
        
        ApiService.register(params: params) { (success, data) in
            self.dismissHUD()
            if success {
                UserInfo.shared.setUserInfo(.token, value: data!["key"] as! String)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNav")
                self.view.window?.rootViewController = vc
            }
        }
        

    }  
}
