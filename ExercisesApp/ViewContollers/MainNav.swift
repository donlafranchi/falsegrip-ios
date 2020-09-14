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

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserInfo.shared.appleID) { (credentialState, error) in
            print(UserInfo.shared.appleID)
            print(UserInfo.shared.username)
            
            switch credentialState {
            case .authorized:
                
                self.showHUD()
                let params = [
                    "apple_id": UserInfo.shared.appleID] as [String : Any]
                
                ApiService.login(params: params) { (success, data) in
                    self.dismissHUD()
                    if success {
                        
                        print(data!["key"])
                        UserInfo.shared.setUserInfo(.token, value: data!["key"] as! String)
                        
                        DispatchQueue.main.async {
                            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNav")
                            self.view.window?.rootViewController = vc
                        }
                    }else{
                        DispatchQueue.main.async {
                            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
                            self.view.window?.rootViewController = vc
                         }
                    }
                }
                


                break
            case .revoked, .notFound:
                DispatchQueue.main.async {
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
                    self.view.window?.rootViewController = vc
                 }
            default:
                break
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
