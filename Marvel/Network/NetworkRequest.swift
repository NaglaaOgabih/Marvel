//
//  NetworkRequest.swift
//  Marvel
//
//  Created by Naglaa Ogabih on 14/09/2022.
//

import UIKit
import Alamofire

class NetworkRequest{
    class func Request(vc: UIViewController ,url : String ,method: HTTPMethod, parameters: [String : Any]?, headers: [String: String]?, completionHandler: @escaping (AFDataResponse<Any>?,ErrorHandler?)->Void){
        AF.request(url, method: method, parameters: parameters ?? [String: Any](),encoding: URLEncoding.default, headers: nil).responseJSON { (response:AFDataResponse) in
            switch(response.result) {
            case .success(let value):
                print(value)
                let temp = response.response?.statusCode ?? 400
                print(temp)
                if temp >= 300 {
                    do {
                        let err = try JSONDecoder().decode(ErrorHandler.self, from: response.data!)
                        print(err.message ?? "error")
                        completionHandler(nil, err)
                    }catch{
                        print("error")
                        print(error)
                    }
                }else{
                    print(response.data!)
                    completionHandler(response,nil)
                }
            case .failure(let error):
                let lockString = NSLocalizedString("Something went wrong please try again later", comment: "")
                print(lockString)
                print(error)
                completionHandler(nil,nil)
                break
            }
        }
    }
}
