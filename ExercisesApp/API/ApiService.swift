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

    class func register(params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
        AF.request(APIRouter.register(params)).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data).dictionary
                completion(true, jsonData)
                break
            case .failure(let error):
                completion(false, ["error": error])
                break
            }
        }
    }
    
   class func login(params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
        AF.request(APIRouter.login(params)).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if let dict = data as? [String: Any] {
                    completion(true, dict)
                } else {
                    completion(false, [:])
                }
                break
            case .failure(let error):
                completion(false, ["error": error])
                break
            }
        }
    }
}
