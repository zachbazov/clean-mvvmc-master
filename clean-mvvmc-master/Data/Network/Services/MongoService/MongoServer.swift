//
//  MongoServer.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation
import UIKit
import URLDataTransfer
import CodeBureau

protocol MongoServerDelegate: AnyObject {
    func serverDidLaunch(_ server: MongoServer)
    func server(_ server: MongoServer, reauthenticeUserFromStore store: UserResponseStore)
}

final class MongoServer: MongoServable {
    
    let dataTransferService: DataTransferService
    
    let authenticator = MongoAuthenticator()
    
    
    weak var delegate: MongoServerDelegate? {
        didSet {
            delegate?.serverDidLaunch(self)
        }
    }
    
    
    init(host: MongoHostProvidable) {
        guard let url = URL(string: host.absoluteString) else { fatalError() }
        
        let requestConfiguration = URLRequestConfiguration(baseURL: url)
        let urlService = URLService(configuration: requestConfiguration)
        
        self.dataTransferService = DataTransferService(urlService: urlService)
    }
}
