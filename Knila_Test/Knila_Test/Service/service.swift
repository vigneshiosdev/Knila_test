//
//  service.swift
//  Knila_Test
//
//  Created by Jeyakumar on 03/02/21.
//

import Foundation
import SystemConfiguration


class service {
    
    
    static func getUsers(completionHandler:@escaping (( users) -> Void), errorHandler: @escaping ((Error) -> Void)) {
        
        var request = URLRequest(url: URL(string: "\(Constants.ApiFields.main_url)")!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "get"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                
                errorHandler(error!)
            }
            else {
                
                do {
                    
                    // Converting dictionary to data to save it in a coadeble file
                    if(data != nil) {
                        let object = try JSONDecoder().decode(users.self, from: data!)
                        completionHandler(object)
                    }
                }
                catch {
                    
                    errorHandler(error)
                    print(error._userInfo as Any)
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    
}
