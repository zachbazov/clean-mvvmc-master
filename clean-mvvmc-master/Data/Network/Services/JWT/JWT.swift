//
//  JWT.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation
import CryptoKit

struct JWTPayload: Decodable {
    let iat: Int
    let exp: Int
    let id: String
}


struct JWT {
    
    enum Algorithm {
        case hs256
        case none
    }
    
    
    enum Error: Swift.Error {
        case verification(String)
        case signing(String)
        case serialization(String)
        case invalidJWTString
        case invalidKeyID
        case failedVerification
        case invaludUTF8Data
    }
}





//class JWTSigner {
//    
//    private var secretKey: String {
//        return Bundle.main.object(forInfoDictionaryKey: "JWT Secret") as? String ?? ""
//    }
//    
//    
//    let token: String
//    
//    
//    init(token: String) {
//        self.token = token
//    }
//    
//    
//    func data(base64urlEncoded: String) -> Data? {
//        let paddingLength = 4 - base64urlEncoded.count % 4
//        let padding = (paddingLength < 4) ? String(repeating: "=", count: paddingLength) : ""
//        let base64EncodedString = base64urlEncoded
//            .replacingOccurrences(of: "-", with: "+")
//            .replacingOccurrences(of: "_", with: "/")
//            + padding
//        return Data(base64Encoded: base64EncodedString)
//    }
//    
//    private func sign() {
//        let payloadMessage = header + "." + payload
//        let expectedSignature = calculateHMACSHA256(key: secretKey, message: payloadMessage)
//        
//        let payloadBase64 = data(base64urlEncoded: payload)!.base64EncodedString()
//        
//        guard let payloadData = Data(base64Encoded: payloadBase64),
//              let payloadJSON = try? JSONDecoder().decode(JWTPayload.self, from: payloadData) else {
//            fatalError("Failed to decode JWT payload.")
//        }
//        print(payloadJSON)
//        guard let signatureData = data(base64urlEncoded: signature) else {
//            return
//        }
//        
//        if expectedSignature == signatureData {
//            
//            let issuedAt = TimeInterval(payloadJSON.iat)
//            let expiresAt = TimeInterval(payloadJSON.exp)
//            
//            calculateTokenExpiration(issuedAt: issuedAt, expiresAt: expiresAt)
////            calculateTokenExpirationInSeconds(issuedAt: issuedAt, expiresAt: expiresAt)
//            
//        } else {
//            print("invalid")
//        }
//    }
//    func calculateTokenExpiration(issuedAt: TimeInterval, expiresAt: TimeInterval) {
//        // Get the current timestamp
//        let currentTimestamp = Date().timeIntervalSince1970
//        
//        // Calculate the expiration timestamp
//        let expirationTimestamp = expiresAt // Assuming 'expiresAt' is in milliseconds
//        
//        // Calculate the remaining time in seconds
//        let remainingTimeInSeconds = Int(expirationTimestamp - currentTimestamp)
//        
//        // Calculate days, hours, and seconds
//        let secondsInMinute = 60
//        let secondsInHour = 60 * secondsInMinute
//        let secondsInDay = 24 * secondsInHour
//        
//        let remainingDays = remainingTimeInSeconds / secondsInDay
//        let remainingHours = (remainingTimeInSeconds % secondsInDay) / secondsInHour
//        let remainingMinutes = (remainingTimeInSeconds % secondsInHour) / secondsInMinute
//        let remainingSeconds = (remainingTimeInSeconds % secondsInMinute)
//        let isTokenValid = self.isTokenValid(expiresAt: expiresAt)
//        
//        // Print the remaining time
//        print("Time Remaining:")
//        print("Total Time Remaining in Seconds: \(remainingTimeInSeconds)")
//        print("Days: \(remainingDays)")
//        print("Hours: \(remainingHours)")
//        print("Minutes: \(remainingMinutes)")
//        print("Seconds: \(remainingSeconds)")
//        print("isTokenValid: \(isTokenValid)")
//    }
//    func calculateTokenExpirationInSeconds(issuedAt: TimeInterval, expiresAt: TimeInterval) {
//        // Get the current timestamp
//        let currentTimestamp = Date().timeIntervalSince1970
//        
//        // Calculate the expiration timestamp
//        let expirationTimestamp = expiresAt // Assuming 'expiresAt' is in milliseconds
//        
//        // Calculate the remaining time in seconds
//        let remainingTimeInSeconds = Int(expirationTimestamp - currentTimestamp)
//        
//        // Print only the remaining seconds
//        print("Time Remaining (in seconds): \(remainingTimeInSeconds)")
//        let isTokenValid = self.isTokenValid(expiresAt: expiresAt)
//        print("isTokenValid: \(isTokenValid)")
//    }
//    func isTokenValid(expiresAt: TimeInterval) -> Bool {
//        // Get the current timestamp
//        let currentTimestamp = Date().timeIntervalSince1970
//        
//        // Remove the division by 1000 for expiresAt if it's already in seconds
//        let expirationTimestamp = expiresAt
//        
//        // Check if the token has expired
//        if currentTimestamp < expirationTimestamp {
//            // Token is still valid
//            return true
//        } else {
//            // Token has expired
//            
//            let coreDataService = CoreDataService.shared
//            let authService = MongoService.shared.authService
//            let request = HTTPUserDTO.Request(user: authService.user!)
//            let responseStore = UserResponseStore()
//            responseStore.deleteResponse(withRequest: request, in: coreDataService.context())
//            
//            return false
//        }
//    }
//
//    
//    
//    private func calculateHMACSHA256(key: String, message: String) -> Data {
//        let keyData = Data(key.utf8)
//        let messageData = Data(message.utf8)
//        
//        let hmac = HMAC<SHA256>.authenticationCode(for: messageData, using: SymmetricKey(data: keyData))
//        
//        return Data(hmac)
//    }
//}


/*
 struct JWT {
     
     enum Algorithm {
         case hs256
         case none
     }
     
     
     enum Error: Swift.Error {
         case verification(String)
         case signing(String)
         case serialization(String)
     }
 }


 class JWTSigner {
     
     private var secretKey: String {
         return Bundle.main.object(forInfoDictionaryKey: "JWT Secret") as? String ?? ""
     }
     
     
     let token: String
     
     var header: String!
     var payload: String!
     var signature: String!
     
     
     init(token: String) {
         self.token = token
     }
     
     
     func data(base64urlEncoded: String) -> Data? {
         let paddingLength = 4 - base64urlEncoded.count % 4
         let padding = (paddingLength < 4) ? String(repeating: "=", count: paddingLength) : ""
         let base64EncodedString = base64urlEncoded
             .replacingOccurrences(of: "-", with: "+")
             .replacingOccurrences(of: "_", with: "/")
             + padding
         return Data(base64Encoded: base64EncodedString)
     }
     
     func decompose() {
         let components = token.components(separatedBy: ".")
         
         if components.count != 3 {
             fatalError("JWT is not valid.")
         }
         
         header = components[0]
         payload = components[1]
         signature = components[2]
         
         sign()
     }
     
     private func sign() {
         let payloadMessage = header + "." + payload
         let expectedSignature = calculateHMACSHA256(key: secretKey, message: payloadMessage)
         
         let payloadBase64 = data(base64urlEncoded: payload)!.base64EncodedString()
         
         guard let payloadData = Data(base64Encoded: payloadBase64),
               let payloadJSON = try? JSONDecoder().decode(JWTPayload.self, from: payloadData) else {
             fatalError("Failed to decode JWT payload.")
         }
         print(payloadJSON)
         guard let signatureData = data(base64urlEncoded: signature) else {
             return
         }
         
         if expectedSignature == signatureData {
             
             let issuedAt = TimeInterval(payloadJSON.iat)
             let expiresAt = TimeInterval(payloadJSON.exp)
             
             calculateTokenExpiration(issuedAt: issuedAt, expiresAt: expiresAt)
 //            calculateTokenExpirationInSeconds(issuedAt: issuedAt, expiresAt: expiresAt)
             
         } else {
             print("invalid")
         }
     }
     func calculateTokenExpiration(issuedAt: TimeInterval, expiresAt: TimeInterval) {
         // Get the current timestamp
         let currentTimestamp = Date().timeIntervalSince1970
         
         // Calculate the expiration timestamp
         let expirationTimestamp = expiresAt // Assuming 'expiresAt' is in milliseconds
         
         // Calculate the remaining time in seconds
         let remainingTimeInSeconds = Int(expirationTimestamp - currentTimestamp)
         
         // Calculate days, hours, and seconds
         let secondsInMinute = 60
         let secondsInHour = 60 * secondsInMinute
         let secondsInDay = 24 * secondsInHour
         
         let remainingDays = remainingTimeInSeconds / secondsInDay
         let remainingHours = (remainingTimeInSeconds % secondsInDay) / secondsInHour
         let remainingMinutes = (remainingTimeInSeconds % secondsInHour) / secondsInMinute
         let remainingSeconds = (remainingTimeInSeconds % secondsInMinute)
         let isTokenValid = self.isTokenValid(expiresAt: expiresAt)
         
         // Print the remaining time
         print("Time Remaining:")
         print("Total Time Remaining in Seconds: \(remainingTimeInSeconds)")
         print("Days: \(remainingDays)")
         print("Hours: \(remainingHours)")
         print("Minutes: \(remainingMinutes)")
         print("Seconds: \(remainingSeconds)")
         print("isTokenValid: \(isTokenValid)")
     }
     func calculateTokenExpirationInSeconds(issuedAt: TimeInterval, expiresAt: TimeInterval) {
         // Get the current timestamp
         let currentTimestamp = Date().timeIntervalSince1970
         
         // Calculate the expiration timestamp
         let expirationTimestamp = expiresAt // Assuming 'expiresAt' is in milliseconds
         
         // Calculate the remaining time in seconds
         let remainingTimeInSeconds = Int(expirationTimestamp - currentTimestamp)
         
         // Print only the remaining seconds
         print("Time Remaining (in seconds): \(remainingTimeInSeconds)")
         let isTokenValid = self.isTokenValid(expiresAt: expiresAt)
         print("isTokenValid: \(isTokenValid)")
     }
     func isTokenValid(expiresAt: TimeInterval) -> Bool {
         // Get the current timestamp
         let currentTimestamp = Date().timeIntervalSince1970
         
         // Remove the division by 1000 for expiresAt if it's already in seconds
         let expirationTimestamp = expiresAt
         
         // Check if the token has expired
         if currentTimestamp < expirationTimestamp {
             // Token is still valid
             return true
         } else {
             // Token has expired
             
             let coreDataService = CoreDataService.shared
             let authService = MongoService.shared.authService
             let request = HTTPUserDTO.Request(user: authService.user!)
             let responseStore = UserResponseStore()
             responseStore.deleteResponse(withRequest: request, in: coreDataService.context())
             
             return false
         }
     }

     
     
     private func calculateHMACSHA256(key: String, message: String) -> Data {
         let keyData = Data(key.utf8)
         let messageData = Data(message.utf8)
         
         let hmac = HMAC<SHA256>.authenticationCode(for: messageData, using: SymmetricKey(data: keyData))
         
         return Data(hmac)
     }
 }

 struct JWTPayload: Decodable {
     let iat: Int
     let exp: Int
     let id: String
 }

 */
