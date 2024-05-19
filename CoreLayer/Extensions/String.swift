//
//  String.swift
//  Veronica
//
//  Created by Дмитрий Савинов on 20.10.2020.
//

import Foundation

extension String {
    
    /// Replacing occurences of a dictionary keys in String with his values
    /// - Parameter replacement: dictionary of words that needs to be changed with another options
    /// - Returns: a new string in which all occurrences of a replacement keys changed to his values
    public func replacingOccurrences(with replacement: [String: String]) -> String {
        var processedData = self
        for element in replacement {
            processedData = processedData.replacingOccurrences(of: element.key, with: element.value)
        }
        return processedData
    }

    /// Capitalizes first letter of current string
    public mutating func capitalizeFirstLetter() {
        self = prefix(1).uppercased() + dropFirst()
    }
    
    public var capitalizedFirstLetter: String {
        prefix(1).uppercased() + dropFirst()
    }
    
    /// Lowercases first letter of current string
    public var lowercasedFirstLetter: String {
       prefix(1).lowercased() + dropFirst()
    }
}
