//
//  ParameterEncoder.swift
//  DotaHeroesParse
//
//  Created by Олег on 03.08.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters where nil"
    case encodingFailed = "Parameter encoding failed"
    case missingURL = "URL is nil"
}
