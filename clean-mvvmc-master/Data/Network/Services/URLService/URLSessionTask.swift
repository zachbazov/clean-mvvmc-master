//
//  URLSessionTask.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import CodeBureau

final class URLSessionTask: URLSessionTaskable {
    
    var task: URLSessionTaskCancellable? {
        willSet {
            task?.cancel()
        }
    }
    
    var isCancelled: Bool = false
}

extension URLSessionTask: URLSessionTaskCancellable {
    
    func cancel() {
        task?.cancel()
        
        isCancelled = true
    }
}
