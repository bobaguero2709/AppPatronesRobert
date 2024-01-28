//
//  NetworkError.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

enum NetworkError: Error {
    case malformedURL
    case dataFormatting
    case other
    case noData
    case errorCode(Int?)
    case tokenFormatError
    case decoding
}
