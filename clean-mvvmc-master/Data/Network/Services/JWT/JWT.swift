//
//  JWT.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

public struct JWT<T: Payload>: Codable {
    
    public var header: Header
    
    public var payload: T
    
    
    public init(header: Header = Header(), payload: T) {
        self.header = header
        self.payload = payload
    }
    
    public init(jwtString: String, verifier: JWTVerifier) throws {
        
        let components = jwtString.components(separatedBy: ".")
        
        guard components.count == 2 || components.count == 3,
            let headerData = JWTDecoder.data(base64urlEncoded: components[0]),
            let payloadData = JWTDecoder.data(base64urlEncoded: components[1])
        else {
            throw JWTError.invalidJWTString
        }
        
        guard JWT.verify(jwtString, using: verifier) else {
            throw JWTError.failedVerification
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        
        let header = try jsonDecoder.decode(Header.self, from: headerData)
        let payload = try jsonDecoder.decode(T.self, from: payloadData)
        
        self.header = header
        self.payload = payload
    }
    
    
    mutating public func sign(using jwtSigner: JWTSigner) throws -> String {
        var tempHeader = header
        tempHeader.alg = jwtSigner.name
        
        let headerString = try tempHeader.encode()
        let payloadString = try payload.encode()
        
        header.alg = tempHeader.alg
        
        return try jwtSigner.sign(header: headerString, payload: payloadString)
    }
    
    static public func verify(_ jwt: String, using jwtVerifier: JWTVerifier) -> Bool {
        return jwtVerifier.verify(jwt: jwt)
    }
    
    public func validatePayload(leeway: TimeInterval = 0) -> ValidatePayloadResult {
        
        guard let expiresAtDate = payload.exp else { fatalError() }
        
        let currentTimestamp = Date()
        
        if currentTimestamp + leeway > expiresAtDate {
            return .expired
        }
        
        return .success
    }
    
    @available(iOS 13.0.0, *)
    public func validatePayload(leeway: TimeInterval = 0) async throws -> ValidatePayloadResult {
        
        guard let expiresAtDate = payload.exp else {
            throw JWTError.failedVerification
        }

        let currentTimestamp = Date()

        if currentTimestamp + leeway > expiresAtDate {
            return .expired
        }

        return .success
    }
}
