//
//  NBSServiceManager.swift
//  DemoBank
//
//  Created by Vikram on 11/26/16.
//  Copyright © 2016 SDL. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
import KRProgressHUD

func getBaseApiUrl() -> String
{
    return "https://silentium.app/api/"
}

class APINAME {
    public var ACTIVATIONCODE  =  getBaseApiUrl() + "getActivationCode.php"
    public var PHONEACTOVATION  =  getBaseApiUrl() + "getActivationCode.php"
}

class ServiceManager: NSObject {
    
    static let sharedInstance : ServiceManager = {
        let instance = ServiceManager()
        return instance
    }()

    func postRequest(parameterDict:[String : Any], URL aUrl: String, block: @escaping (NSDictionary?, NSError?) -> Void) {
        if Reachability.Connection.self != .none {
            KRProgressHUD.show()
            Alamofire.request(aUrl, method: HTTPMethod.post , parameters: parameterDict,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    do {
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            block(JSON,nil)
                            
                        }
                        KRProgressHUD.dismiss()
                    }
                    break
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    print(error)
                }
            }
        }
    }
    
    func gettRequest(parameterDict:[String : Any], URL aUrl: String, block: @escaping (NSDictionary?, NSError?) -> Void)
    {
        Alamofire.request(aUrl, method: HTTPMethod.get , parameters: parameterDict,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        block(JSON,nil)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension URL
{
    /// Creates an NSURL with url-encoded parameters.
    init?(string : String, parameters : [String : String])
    {
        guard var components = URLComponents(string: string) else { return nil }
        
        components.queryItems = parameters.map { return URLQueryItem(name: $0, value: $1) }
        
        guard let url = components.url else { return nil }
        
        // Kinda redundant, but we need to call init.
        self.init(string: url.absoluteString)
    }
}
