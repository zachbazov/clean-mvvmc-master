//
//  PayloadStandardJWT.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/09/2023.
//

import Foundation

public class PayloadStandardJWT: Payload {
    
    /// Initialize a `PayloadStandardJWT`
    public init(iss: String? = nil,
         sub: String? = nil,
         aud: [String]? = nil,
         exp: Int,
         nbf: Int,
         iat: Int,
         jti: String? = nil
    ) {
        self.iss = iss
        self.sub = sub
        self.aud = aud
        self.exp = Date(timeIntervalSince1970: TimeInterval(exp))
        self.nbf = Date(timeIntervalSince1970: TimeInterval(nbf))
        self.iat = Date(timeIntervalSince1970: TimeInterval(iat))
        self.jti = jti
    }
    
    /**
     The "iss" (issuer) claim identifies the principal that issued the
     JWT.  The processing of this claim is generally application specific.
     The "iss" value is a case-sensitive.
     */
    public var iss: String?
    
    /**
     The "sub" (subject) claim identifies the principal that is the
     subject of the JWT.  The claims in a JWT are normally statements
     about the subject.  The subject value MUST either be scoped to be
     locally unique in the context of the issuer or be globally unique.
     The processing of this claim is generally application specific.  The
     "sub" value is case-sensitive.
     */
    public var sub: String?
    
    /**
     The "aud" (audience) claim identifies the recipients that the JWT is
     intended for.  Each principal intended to process the JWT MUST
     identify itself with a value in the audience claim.  If the principal
     processing the claim does not identify itself with a value in the
     "aud" claim when this claim is present, then the JWT MUST be
     rejected. The interpretation of audience values is generally application specific.
     The "aud" value is case-sensitive.
     */
    public var aud: [String]?
    
    /**
     The "exp" (expiration time) claim identifies the expiration time on
     or after which the JWT MUST NOT be accepted for processing.  The
     processing of the "exp" claim requires that the current date/time
     MUST be before the expiration date/time listed in the "exp" claim.
     Implementers MAY provide for some small leeway, usually no more than
     a few minutes, to account for clock skew.
     */
    public var exp: Date?
    
    /**
     The "nbf" (not before) claim identifies the time before which the JWT
     MUST NOT be accepted for processing.  The processing of the "nbf"
     claim requires that the current date/time MUST be after or equal to
     the not-before date/time listed in the "nbf" claim.  Implementers MAY
     provide for some small leeway, usually no more than a few minutes, to
     account for clock skew.
     */
    public var nbf: Date?
    
    /**
     The "iat" (issued at) claim identifies the time at which the JWT was
     issued.  This claim can be used to determine the age of the JWT.
     */
    public var iat: Date?
    
    /**
     The "jti" (JWT ID) claim provides a unique identifier for the JWT.
     The identifier value MUST be assigned in a manner that ensures that
     there is a negligible probability that the same value will be
     accidentally assigned to a different data object; if the application
     uses multiple issuers, collisions MUST be prevented among values
     produced by different issuers as well.  The "jti" claim can be used
     to prevent the JWT from being replayed.  The "jti" value is case-
     sensitive
     */
    public var jti: String?
}


public extension PayloadStandardJWT {
    
    func log() {
        let logger = JWTLogger()
        
        logger.log(issuedAt: iat?.timeIntervalSince1970 ?? .zero, expiresAt: exp?.timeIntervalSince1970 ?? .zero)
    }
}
