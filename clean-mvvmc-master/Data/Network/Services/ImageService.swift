//
//  ImageService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import UIKit.UIImage

protocol ImageDownloadable {
    func download(url: URL, identifier: NSString, completion: ((UIImage?) -> Void)?)
}


final class URLImageProtocol: URLProtocol {
    
    var cancelledOrComplete: Bool = false
    
    var block: DispatchWorkItem!
    
    
    private let dispatchQueue = DispatchQueue(label: "com.netflix.URLImageProtocol",
                                              qos: .userInitiated,
                                              attributes: .concurrent,
                                              autoreleaseFrequency: .workItem)
    
    // MARK: URLProtocol
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return a == b
    }
    
    override func startLoading() {
        guard let requestUrl = request.url,
              let urlClient = client
        else { return }
        
        block = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            if self.cancelledOrComplete == false {
                guard let imageUrl = URL(string: requestUrl.absoluteString) else { return }
                
                if let data = try? Data(contentsOf: imageUrl) {
                    urlClient.urlProtocol(self, didLoad: data)
                    urlClient.urlProtocolDidFinishLoading(self)
                }
            }
            
            self.cancelledOrComplete = true
        }
        
        let time = DispatchTime(uptimeNanoseconds: 500 * NSEC_PER_MSEC)
        
        dispatchQueue.asyncAfter(deadline: time, execute: block)
    }
    
    override func stopLoading() {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            
            if self.cancelledOrComplete == false,
               let cancelledBlock = self.block {
                
                cancelledBlock.cancel()
                
                self.cancelledOrComplete = true
            }
        }
    }
}


final class ImageService {
    
    private lazy var session: URLSession = createURLSession()
    
    private(set) var cache = NSCache<NSString, UIImage>()
}

extension ImageService {
    
    private func createURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        
        configuration.protocolClasses = [URLImageProtocol.classForCoder()]
        configuration.timeoutIntervalForRequest = 5
        
        return URLSession(configuration: configuration)
    }
}


extension ImageService: ImageDownloadable {
    
    func download(url: URL, identifier: NSString, completion: ((UIImage?) -> Void)?) {
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
                  let image = UIImage(data: data)
            else {
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
