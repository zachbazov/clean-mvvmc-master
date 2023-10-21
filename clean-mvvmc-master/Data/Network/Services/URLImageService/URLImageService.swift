//
//  URLImageService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import UIKit

final class URLImageService {
    
    private lazy var session: URLSession = createURLSession()
    
    private(set) var cache = NSCache<NSString, UIImage>()
}


extension URLImageService {
    
    private func createURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        
        configuration.protocolClasses = [URLImageProtocol.classForCoder()]
        configuration.timeoutIntervalForRequest = 5
        
        return URLSession(configuration: configuration)
    }
}


extension URLImageService: URLImageRequestable {
    
    func load(url: URL, identifier: NSString, completion: ((UIImage?) -> Void)?) {
        if let cachedImage = cache.object(forKey: identifier as NSString) {
            
            DispatchQueue.main.async {
                completion?(cachedImage)
            }
            
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                return completion?(nil) ?? {}()
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                self.cache.setObject(image, forKey: identifier)
                
                DispatchQueue.main.async {
                    completion?(image)
                }
            }
        }.resume()
    }
}
