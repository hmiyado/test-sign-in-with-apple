//
//  ClientSecretClaim.swift
//  test-sign-in-withj-apple
//
//  Created by 吉田拓真 on 2020/06/28.
//  Copyright © 2020 hmiyado. All rights reserved.
//

import Foundation
import SwiftJWT

public class ClientSecretClaim : Claims {
    
    init(iss: String, iat: Date, exp: Date) {
        self.iss = iss
        self.iat = iat
        self.exp = exp
    }
    
    public var iss: String
    public var iat: Date
    public var exp: Date
    public let aud: String = "https://appleid.apple.com"
    public let sub: String = "com.github.hmiyado.test-sign-in-with-apple"
}
