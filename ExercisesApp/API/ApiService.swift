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
    
    // MARK: - Auth -
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
                    completion(false,jsonData)
                 }
             case .failure( _):
                let jsonData = JSON(response.data as Any).dictionaryObject
                completion(false,jsonData)
             }
         }
    }
    
    // MARK: - Profile -
    
    class func getProfile(completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
     
          let url = baseURLPath + "api/users/me/"
         
          AF.request(url, method: .get)
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
    
    class func updateProfile(id: String,params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
    
        let url = baseURLPath + "api/users/\(id)/"
        
        AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default)
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
    
    // MARK: - Workout -
    
    class func getWorkouts(page: Int,params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
     
          let url = baseURLPath + "api/workouts/?page=\(page)"
         
          AF.request(url, method: .get, parameters: params)
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
    
    class func createWorkout(params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
      
           let url = baseURLPath + "api/workouts/"
          
         AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
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
     
     class func updateWorkout(id: String,params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
      
         let url = baseURLPath + "api/workouts/\(id)/"
          
         AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default)
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
    
     class func updateWorkout2(id: String,params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
     
         let url = baseURLPath + "api/workouts/\(id)/"
         
         AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default)
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
     
     class func getWorkout(id: String, completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
      
           let url = baseURLPath + "api/workouts/\(id)/"
          
         AF.request(url, method: .get, encoding: JSONEncoding.default)
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
    
    class func deleteWorkout(id: String, completion: @escaping (_ success: Bool) -> Void) {
     
          let url = baseURLPath + "api/workouts/\(id)/"
         
        AF.request(url, method: .delete)
           .responseJSON { response in
              switch response.result {
              case .success( _):
                  if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {
                      completion(true)
                  }else{
                     completion(false)
                  }
              case .failure( _):
                 completion(false)
              }
          }
    }
    
    // MARK: - Exercises -
    
    class func getAllExercises(page: Int,params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
     
          let url = baseURLPath + "api/exercises/?page=\(page)"
         
          AF.request(url, method: .get, parameters: params)
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
    
    class func getExerciseHistory(id: String, completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
     
          let url = baseURLPath + "api/exercises/\(id)/history/"
         
        AF.request(url, method: .get)
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
    
 // MARK: - Sets -
    
    class func getWorkoutSets(parent_workout: String, completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
     
          let url = baseURLPath + "api/workouts/\(parent_workout)/sets/"
         
        AF.request(url, method: .get)
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
    
    class func deleteExercise(id: String,params: [String: Any], completion: @escaping (_ success: Bool) -> Void) {
     
        let url = baseURLPath + "api/workouts/\(id)/"
         
        AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default)
           .responseJSON { response in
              switch response.result {
              case .success( _):
                  if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {
                      completion(true)
                  }else{
                     completion(false)
                  }
              case .failure( _):
                 completion(false)
              }
          }
     }
    
    class func workoutSets(workoutId: String,params: [String: Any], completion: @escaping (_ success: Bool, _ data: [String: Any]?) -> Void) {
     
        let url = baseURLPath + "api/workouts/\(workoutId)/sets/"
         
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
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
    
    class func deleteSets(workoutId: String, id: Int, completion: @escaping (_ success: Bool) -> Void) {
     
        let url = baseURLPath + "api/workouts/\(workoutId)/sets/\(id)/"
         
        AF.request(url, method: .delete)
           .responseJSON { response in
              switch response.result {
              case .success( _):
                  if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {
                      completion(true)
                  }else{
                     completion(false)
                  }
              case .failure( _):
                 completion(false)
              }
          }
     }
}
