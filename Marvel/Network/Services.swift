//
//  Services.swift
//  Marvel
//
//  Created by Naglaa Ogabih on 14/09/2022.
//

import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class Services {
    
    static var publicKey = "4999ce22eaf8b08a840e1e645590978f"
    static var privateKey = "fb759cde0d0a3777ccad232b351ad6d70436564f"
    static let timestamp = NSDate().timeIntervalSince1970
    static let myTimeInterval = TimeInterval(timestamp)
    static let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
    static let hash = MD5(string: stringToHash)
    static let md5Hex =  hash.map { String(format: "%02hhx", $0) }.joined()
    static var stringToHash = "\(timestamp)" + privateKey + publicKey
    static var url = "https://gateway.marvel.com/v1/public/characters?apikey=\(publicKey)&ts=\(timestamp)&hash=\(md5Hex)"

    //MARK: - GetCharacters
    class func getCharacters(vc : UIViewController , completionHandler: @escaping (CharactersModel?,String?) -> Void){
        NetworkRequest.Request(vc: vc, url: url, method: .get, parameters: nil , headers: nil){
            response , error in
            if response == nil && error == nil{
                completionHandler(nil,nil)
            }else{
                if error == nil{
                    do {
                        let ParsedResult = try JSONDecoder().decode(CharactersModel?.self,from:(response?.data)!)
                        // if success == true return data and error = nil
                        // if success == false retrun data with nil and error with String
                        (ParsedResult?.code == 200) ? completionHandler(ParsedResult,nil) : completionHandler(nil,ParsedResult?.status)
                    }catch{
                        print("Error")
                        print (error)
                    }
                }else{
                    completionHandler(nil, error?.message)
                }
            }
        }
    }
}
func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }

