//
//  MainNav.swift
//  ExercisesApp
//
//  Created by developer on 9/5/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import AuthenticationServices

class MainNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
        
        if UserInfo.shared.token.isEmpty {
            DispatchQueue.main.async {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
                self.view.window?.rootViewController = vc
             }
        }else{
            self.showHUD()
            let params = [
                "apple_id": UserInfo.shared.appleID] as [String : Any]
            
            ApiService.login(params: params) { (success, data) in
                
                if success {
                    
                    UserInfo.shared.setUserInfo(.token, value: data!["key"] as! String)
                    
                    DispatchQueue.main.async {
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNav")
                        self.view.window?.rootViewController = vc
                    }
                }else{
                    self.dismissHUD()
                    DispatchQueue.main.async {
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
                        self.view.window?.rootViewController = vc
                     }
                }
            }
        }
        

//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: UserInfo.shared.appleID) { (credentialState, error) in
//            print(UserInfo.shared.appleID)
//            print(UserInfo.shared.username)
//
//            switch credentialState {
//            case .authorized:
//
//
//
//
//
//                break
//            case .revoked, .notFound:
//                DispatchQueue.main.async {
//                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
//                    self.view.window?.rootViewController = vc
//                 }
//            default:
//                break
//            }
//        }
    }
}
