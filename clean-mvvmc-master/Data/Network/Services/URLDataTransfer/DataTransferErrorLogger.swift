//
//  DataTransferErrorLogger.swift
//
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import CodeBureau

public struct DataTransferErrorLogger: DataTransferErrorLoggable {
    
    public func log(error: Error) {
        debugPrint(.linebreak, "------------")
        debugPrint(.error, error.localizedDescription)
    }
}
