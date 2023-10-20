//
//  ServerError.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct ServerError {
    let statusCode: Int
    let status: String
    let isOperational: Bool
}
