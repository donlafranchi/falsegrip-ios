//
//  ApiService.swift
//  CVAIApp
//
//  Created by developer on 8/13/20.
//  Copyright © 2020 br. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiService: NSObject {

    static let baseURLPath = "http://humblerings.com/"
    
    class func register(params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
        AF.request(APIRouter.register(params)).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data).dictionaryObject
                if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {
                    completion(true, jsonData)
                }else{
                    completion(false, jsonData)
                }
                break
            case .failure(let error):
                
                completion(false, ["error": error])
                break
            }
        }
    }
    
   class func login(params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
    
         let url = baseURLPath + "auth/sign-in/"
        
         AF.request(url, method: .post, parameters: params)
          .responseJSON { response in
             switch response.result {
             case .success(let data):
                 let jsonData = JSON(data).dictionaryObject
                 if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {
                    
                     completion(true,jsonData)
                 }else{
                    completion(false,["error":response.response.debugDescription])
                 }
             case .failure(let error):
                completion(false,["error":error])
             }
         }
       
    }
}
