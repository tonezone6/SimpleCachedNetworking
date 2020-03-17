//
//  File.swift
//  
//
//  Created by Alex on 17/03/2020.
//

import Foundation

enum ErrorMock: LocalizedError {
    case test
    
    var errorDescription: String? {
        return "\(self)"
    }
}
