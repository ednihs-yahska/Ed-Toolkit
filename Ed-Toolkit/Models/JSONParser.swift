//
//  JSONParser.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/24/25.
//

import Foundation

/// A custom JSON parser that's more forgiving with key formatting while maintaining strict value parsing
class JSONParser {
    
    private var input: String = ""
    private var index: String.Index
    private var position: Int = 0
    
    init() {
        self.index = "".startIndex
    }
    
    /// Parse a JSON string with flexible key formatting
    /// - Parameter jsonString: The JSON string to parse
    /// - Returns: The parsed JSON object (Dictionary, Array, or primitive)
    /// - Throws: JSONParseError if parsing fails
    func parse(_ jsonString: String) throws -> Any {
        guard !jsonString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw JSONParseError.emptyInput
        }
        
        // Normalize quotes and prepare input
        self.input = normalizeQuotes(jsonString)
        self.index = input.startIndex
        self.position = 0
        
        skipWhitespace()
        
        let result = try parseValue()
        
        skipWhitespace()
        
        // Ensure we've consumed the entire input
        if index < input.endIndex {
            let char = input[index]
            throw JSONParseError.invalidCharacter(char, position: position)
        }
        
        return result
    }
    
    // MARK: - Quote Normalization
    
    /// Convert all types of quotes to straight double quotes
    private func normalizeQuotes(_ jsonString: String) -> String {
        var normalized = jsonString
        
        // Map of quote characters to replace with straight double quotes
        let quoteMapping: [String: String] = [
            "\u{201C}": "\"",  // Left double quotation mark
            "\u{201D}": "\"",  // Right double quotation mark
            "\u{2018}": "\"",  // Left single quotation mark
            "\u{2019}": "\"",  // Right single quotation mark
            "\u{201A}": "\"",  // Single low-9 quotation mark
            "\u{201E}": "\"",  // Double low-9 quotation mark
            "\u{2039}": "\"",  // Single left-pointing angle quotation mark
            "\u{203A}": "\"",  // Single right-pointing angle quotation mark
            "\u{00AB}": "\"",  // Left-pointing double angle quotation mark
            "\u{00BB}": "\"",  // Right-pointing double angle quotation mark
        ]
        
        // Replace smart quotes with straight quotes
        for (smart, straight) in quoteMapping {
            normalized = normalized.replacingOccurrences(of: smart, with: straight)
        }
        
        // Handle single quotes around keys and values
        normalized = normalizeSingleQuotes(normalized)
        
        // Handle unquoted keys
        normalized = normalizeUnquotedKeys(normalized)
        
        return normalized
    }
    
    /// Convert single quotes to double quotes while preserving escaped quotes
    private func normalizeSingleQuotes(_ input: String) -> String {
        var result = ""
        var i = input.startIndex
        var inDoubleQuotes = false
        
        while i < input.endIndex {
            let char = input[i]
            
            if char == "\"" && (i == input.startIndex || input[input.index(before: i)] != "\\") {
                inDoubleQuotes.toggle()
                result.append(char)
            } else if char == "'" && !inDoubleQuotes {
                // Convert single quote to double quote
                result.append("\"")
            } else {
                result.append(char)
            }
            
            i = input.index(after: i)
        }
        
        return result
    }
    
    /// Add quotes around unquoted keys in objects
    private func normalizeUnquotedKeys(_ input: String) -> String {
        var result = ""
        var i = input.startIndex
        var inString = false
        var depth = 0
        var expectingKey = false
        
        while i < input.endIndex {
            let char = input[i]
            
            if char == "\"" && (i == input.startIndex || input[input.index(before: i)] != "\\") {
                inString.toggle()
                result.append(char)
            } else if !inString {
                switch char {
                case "{":
                    depth += 1
                    expectingKey = true
                    result.append(char)
                case "}":
                    depth -= 1
                    expectingKey = false
                    result.append(char)
                case ":":
                    expectingKey = false
                    result.append(char)
                case ",":
                    if depth > 0 {
                        expectingKey = true
                    }
                    result.append(char)
                case " ", "\t", "\n", "\r":
                    result.append(char)
                default:
                    if expectingKey && char.isLetter {
                        // Found start of unquoted key
                        let keyStart = i
                        var keyEnd = i
                        
                        // Find end of key
                        while keyEnd < input.endIndex {
                            let keyChar = input[keyEnd]
                            if keyChar.isWhitespace || keyChar == ":" {
                                break
                            }
                            keyEnd = input.index(after: keyEnd)
                        }
                        
                        // Extract and quote the key
                        let key = String(input[keyStart..<keyEnd])
                        result.append("\"\(key)\"")
                        
                        // Update position to after the key
                        i = input.index(before: keyEnd)
                        expectingKey = false
                    } else {
                        result.append(char)
                    }
                }
            } else {
                result.append(char)
            }
            
            i = input.index(after: i)
        }
        
        return result
    }
    
    // MARK: - Core Parsing Methods
    
    private func parseValue() throws -> Any {
        skipWhitespace()
        
        guard index < input.endIndex else {
            throw JSONParseError.unexpectedEndOfInput
        }
        
        let char = input[index]
        
        switch char {
        case "{":
            return try parseObject()
        case "[":
            return try parseArray()
        case "\"":
            return try parseString()
        case "t", "f":
            return try parseBoolean()
        case "n":
            return try parseNull()
        case "-", "0"..."9":
            return try parseNumber()
        default:
            throw JSONParseError.invalidCharacter(char, position: position)
        }
    }
    
    private func parseObject() throws -> [String: Any] {
        var object: [String: Any] = [:]
        
        // Consume opening brace
        advance()
        skipWhitespace()
        
        // Handle empty object
        if index < input.endIndex && input[index] == "}" {
            advance()
            return object
        }
        
        while true {
            skipWhitespace()
            
            // Parse key
            guard index < input.endIndex else {
                throw JSONParseError.unexpectedEndOfInput
            }
            
            let key = try parseString()
            
            // Check for duplicate keys
            if object[key] != nil {
                throw JSONParseError.duplicateKey(key, position: position)
            }
            
            skipWhitespace()
            
            // Expect colon
            guard index < input.endIndex && input[index] == ":" else {
                throw JSONParseError.expectedColon(position: position)
            }
            advance()
            
            // Parse value
            let value = try parseValue()
            object[key] = value
            
            skipWhitespace()
            
            guard index < input.endIndex else {
                throw JSONParseError.unexpectedEndOfInput
            }
            
            let char = input[index]
            if char == "}" {
                advance()
                break
            } else if char == "," {
                advance()
                continue
            } else {
                throw JSONParseError.expectedCommaOrClosingBrace(position: position)
            }
        }
        
        return object
    }
    
    private func parseArray() throws -> [Any] {
        var array: [Any] = []
        
        // Consume opening bracket
        advance()
        skipWhitespace()
        
        // Handle empty array
        if index < input.endIndex && input[index] == "]" {
            advance()
            return array
        }
        
        while true {
            let value = try parseValue()
            array.append(value)
            
            skipWhitespace()
            
            guard index < input.endIndex else {
                throw JSONParseError.unexpectedEndOfInput
            }
            
            let char = input[index]
            if char == "]" {
                advance()
                break
            } else if char == "," {
                advance()
                continue
            } else {
                throw JSONParseError.expectedCommaOrClosingBracket(position: position)
            }
        }
        
        return array
    }
    
    private func parseString() throws -> String {
        // Consume opening quote
        advance()
        
        var string = ""
        
        while index < input.endIndex {
            let char = input[index]
            
            if char == "\"" {
                advance()
                return string
            } else if char == "\\" {
                advance()
                guard index < input.endIndex else {
                    throw JSONParseError.invalidStringEscape(position: position)
                }
                
                let escaped = input[index]
                switch escaped {
                case "\"", "\\", "/":
                    string.append(escaped)
                case "b":
                    string.append("\u{0008}")
                case "f":
                    string.append("\u{000C}")
                case "n":
                    string.append("\n")
                case "r":
                    string.append("\r")
                case "t":
                    string.append("\t")
                case "u":
                    string.append(try parseUnicodeEscape())
                    continue // parseUnicodeEscape advances the index
                default:
                    throw JSONParseError.invalidStringEscape(position: position)
                }
                advance()
            } else {
                string.append(char)
                advance()
            }
        }
        
        throw JSONParseError.unexpectedEndOfInput
    }
    
    private func parseUnicodeEscape() throws -> Character {
        advance() // Skip 'u'
        
        var hexString = ""
        for _ in 0..<4 {
            guard index < input.endIndex else {
                throw JSONParseError.invalidStringEscape(position: position)
            }
            
            let char = input[index]
            guard char.isHexDigit else {
                throw JSONParseError.invalidStringEscape(position: position)
            }
            
            hexString.append(char)
            advance()
        }
        
        guard let unicodeValue = UInt32(hexString, radix: 16),
              let scalar = UnicodeScalar(unicodeValue) else {
            throw JSONParseError.invalidStringEscape(position: position)
        }
        
        return Character(scalar)
    }
    
    private func parseNumber() throws -> Any {
        let startIndex = index
        var isFloat = false
        
        // Handle negative sign
        if index < input.endIndex && input[index] == "-" {
            advance()
        }
        
        // Parse integer part
        guard index < input.endIndex && input[index].isNumber else {
            throw JSONParseError.invalidNumber(position: position)
        }
        
        if input[index] == "0" {
            advance()
        } else {
            while index < input.endIndex && input[index].isNumber {
                advance()
            }
        }
        
        // Parse decimal part
        if index < input.endIndex && input[index] == "." {
            isFloat = true
            advance()
            
            guard index < input.endIndex && input[index].isNumber else {
                throw JSONParseError.invalidNumber(position: position)
            }
            
            while index < input.endIndex && input[index].isNumber {
                advance()
            }
        }
        
        // Parse exponent part
        if index < input.endIndex && (input[index] == "e" || input[index] == "E") {
            isFloat = true
            advance()
            
            if index < input.endIndex && (input[index] == "+" || input[index] == "-") {
                advance()
            }
            
            guard index < input.endIndex && input[index].isNumber else {
                throw JSONParseError.invalidNumber(position: position)
            }
            
            while index < input.endIndex && input[index].isNumber {
                advance()
            }
        }
        
        let numberString = String(input[startIndex..<index])
        
        if isFloat {
            guard let double = Double(numberString) else {
                throw JSONParseError.invalidNumber(position: position)
            }
            return double
        } else {
            guard let int = Int(numberString) else {
                throw JSONParseError.invalidNumber(position: position)
            }
            return int
        }
    }
    
    private func parseBoolean() throws -> Bool {
        if parseKeyword("true") {
            return true
        } else if parseKeyword("false") {
            return false
        } else {
            let remainingInput = String(input[index...])
            let preview = String(remainingInput.prefix(10))
            throw JSONParseError.invalidLiteral(preview, position: position)
        }
    }
    
    private func parseNull() throws -> NSNull {
        if parseKeyword("null") {
            return NSNull()
        } else {
            let remainingInput = String(input[index...])
            let preview = String(remainingInput.prefix(10))
            throw JSONParseError.invalidLiteral(preview, position: position)
        }
    }
    
    private func parseKeyword(_ keyword: String) -> Bool {
        let endIndex = input.index(index, offsetBy: keyword.count, limitedBy: input.endIndex) ?? input.endIndex
        let substring = String(input[index..<endIndex])
        
        if substring == keyword {
            for _ in 0..<keyword.count {
                advance()
            }
            return true
        }
        
        return false
    }
    
    // MARK: - Helper Methods
    
    private func advance() {
        if index < input.endIndex {
            index = input.index(after: index)
            position += 1
        }
    }
    
    private func skipWhitespace() {
        while index < input.endIndex && input[index].isWhitespace {
            advance()
        }
    }
}

// MARK: - Character Extensions

private extension Character {
    var isHexDigit: Bool {
        return isNumber || ("a"..."f").contains(self) || ("A"..."F").contains(self)
    }
}