//
//  JSONParseError.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/24/25.
//

import Foundation

enum JSONParseError: Error, LocalizedError, Equatable {
    case invalidCharacter(Character, position: Int)
    case unexpectedEndOfInput
    case invalidStringEscape(position: Int)
    case invalidNumber(position: Int)
    case expectedColon(position: Int)
    case expectedCommaOrClosingBrace(position: Int)
    case expectedCommaOrClosingBracket(position: Int)
    case invalidLiteral(String, position: Int)
    case duplicateKey(String, position: Int)
    case emptyInput
    
    var errorDescription: String? {
        switch self {
        case .invalidCharacter(let char, let position):
            return "Invalid character '\(char)' at position \(position)"
        case .unexpectedEndOfInput:
            return "Unexpected end of input"
        case .invalidStringEscape(let position):
            return "Invalid string escape sequence at position \(position)"
        case .invalidNumber(let position):
            return "Invalid number format at position \(position)"
        case .expectedColon(let position):
            return "Expected ':' after key at position \(position)"
        case .expectedCommaOrClosingBrace(let position):
            return "Expected ',' or '}' at position \(position)"
        case .expectedCommaOrClosingBracket(let position):
            return "Expected ',' or ']' at position \(position)"
        case .invalidLiteral(let literal, let position):
            return "Invalid literal '\(literal)' at position \(position)"
        case .duplicateKey(let key, let position):
            return "Duplicate key '\(key)' at position \(position)"
        case .emptyInput:
            return "Empty input provided"
        }
    }
}