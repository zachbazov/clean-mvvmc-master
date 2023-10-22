//
//  UseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

protocol UseCase: UseCaseRequestable {
    
    var repository: Repository { get }
}
