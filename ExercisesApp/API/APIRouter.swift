//
//  APIRouter.swift
//  SafeRole
//
//  Created by Mac on 5/11/20.
//  Copyright © 2020 Modvision Inc. All rights reserved.
//

import Alamofire

public enum APIRouter: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "http://humblerings.com"
    }
    
    case register([String: Any])
    case login([String: Any])
    case update([String: Any])
    case upload([String: Any])
    case download([String: Any])
    case cloudStatus([String: Any])
    case deleteImages([String: Any])
    case sendOtp([String: Any])
    case checkOtp([String: Any])
    
    var method: HTTPMethod {
        switch self {
        case .register, .login, .update, .upload,.deleteImages,.sendOtp,.checkOtp:
            return .post
        case .download,.cloudStatus:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "/auth/sign-up/"
        case .login:
            return "/auth/sign-in/"
        case .update:
            return "/update-users"
        case .upload:
            return "/uploadimage"
        case .download:
            return "/downloadFile"
        case .cloudStatus:
            return "/cloud-status"
        case .deleteImages:
            return "/delete-images"
        case .sendOtp:
             return "/send-otp"
        case .checkOtp:
             return "/check-otp"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .register(let params):
            return params
        case .login(let params):
            return params
        case .update(let params):
            return params
        case .upload(let params):
            return params
        case .download(let params):
            return params
        case .cloudStatus(let params):
            return params
        case .deleteImages(let params):
            return params
        case .sendOtp(let params):
            return params
        case .checkOtp(let params):
            return params
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
}
