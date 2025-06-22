//
//  Ed_ToolkitTests.swift
//  Ed-ToolkitTests
//
//  Created by Akshay Shinde on 6/21/25.
//

import Testing
@testable import Ed_Toolkit
import SwiftUI

// MARK: - JSON Parsing Tests

struct JSONParsingTests {
    
    @Test("Parse valid JSON object")
    func testParseValidJSONObject() throws {
        let jsonString = """
        {
            "name": "John Doe",
            "age": 30,
            "active": true
        }
        """
        
        let data = jsonString.data(using: .utf8)!
        let parsed = try JSONSerialization.jsonObject(with: data, options: [])
        
        #expect(parsed is [String: Any])
        let dict = parsed as! [String: Any]
        #expect(dict["name"] as? String == "John Doe")
        #expect(dict["age"] as? Int == 30)
        #expect(dict["active"] as? Bool == true)
    }
    
    @Test("Parse valid JSON array")
    func testParseValidJSONArray() throws {
        let jsonString = """
        [1, 2, 3, "four", true, null]
        """
        
        let data = jsonString.data(using: .utf8)!
        let parsed = try JSONSerialization.jsonObject(with: data, options: [])
        
        #expect(parsed is [Any])
        let array = parsed as! [Any]
        #expect(array.count == 6)
        #expect(array[0] as? Int == 1)
        #expect(array[3] as? String == "four")
        #expect(array[4] as? Bool == true)
        #expect(array[5] is NSNull)
    }
    
    @Test("Parse nested JSON structure")
    func testParseNestedJSON() throws {
        let jsonString = """
        {
            "user": {
                "profile": {
                    "name": "Alice",
                    "settings": {
                        "theme": "dark",
                        "notifications": true
                    }
                },
                "scores": [95, 87, 92]
            }
        }
        """
        
        let data = jsonString.data(using: .utf8)!
        let parsed = try JSONSerialization.jsonObject(with: data, options: [])
        
        #expect(parsed is [String: Any])
        let root = parsed as! [String: Any]
        let user = root["user"] as! [String: Any]
        let profile = user["profile"] as! [String: Any]
        let settings = profile["settings"] as! [String: Any]
        
        #expect(settings["theme"] as? String == "dark")
        #expect(settings["notifications"] as? Bool == true)
        
        let scores = user["scores"] as! [Int]
        #expect(scores == [95, 87, 92])
    }
    
    @Test("Handle invalid JSON")
    func testInvalidJSON() {
        let invalidJSON = """
        {
            "name": "Missing comma"
            "age": 30
        }
        """
        
        let data = invalidJSON.data(using: .utf8)!
        
        #expect(throws: Error.self) {
            try JSONSerialization.jsonObject(with: data, options: [])
        }
    }
    
    @Test("Handle empty string")
    func testEmptyString() {
        let emptyString = ""
        
        #expect(emptyString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
}

// MARK: - URL Encoding/Decoding Tests

struct URLEncodingTests {
    
    @Test("Encode URL with special characters")
    func testURLEncodingSpecialCharacters() {
        let input = "Hello World! @#$%"
        let encoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // Note: urlQueryAllowed doesn't encode ! and $ characters
        #expect(encoded == "Hello%20World!%20@%23$%25")
    }
    
    @Test("Encode URL with spaces")
    func testURLEncodingSpaces() {
        let input = "test with spaces"
        let encoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        #expect(encoded == "test%20with%20spaces")
    }
    
    @Test("Decode percent-encoded URL")
    func testURLDecoding() {
        let input = "Hello%20World%21"
        let decoded = input.removingPercentEncoding
        
        #expect(decoded == "Hello World!")
    }
    
    @Test("Decode URL with special characters")
    func testURLDecodingSpecialCharacters() {
        let input = "%40%23%24%25%26"
        let decoded = input.removingPercentEncoding
        
        #expect(decoded == "@#$%&")
    }
    
    @Test("Handle already encoded string")
    func testDoubleEncoding() {
        let input = "Hello%20World"
        let encoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        #expect(encoded == "Hello%2520World")
    }
    
    @Test("Handle empty string")
    func testEmptyString() {
        let input = ""
        let encoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        #expect(encoded == "")
    }
    
    @Test("Encode Unicode characters")
    func testUnicodeEncoding() {
        let input = "Hello 世界 🌍"
        let encoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        #expect(encoded == "Hello%20%E4%B8%96%E7%95%8C%20%F0%9F%8C%8D")
    }
}

// MARK: - Diff Algorithm Tests

struct DiffAlgorithmTests {
    
    // Helper function that mimics the diff algorithm from DiffMatcherView
    func computeDiff(leftLines: [String], rightLines: [String]) -> [(content: String, type: DiffType, leftLine: Int?, rightLine: Int?)] {
        var results: [(content: String, type: DiffType, leftLine: Int?, rightLine: Int?)] = []
        
        var leftIndex = 0
        var rightIndex = 0
        
        while leftIndex < leftLines.count || rightIndex < rightLines.count {
            if leftIndex >= leftLines.count {
                results.append((
                    content: rightLines[rightIndex],
                    type: .addition,
                    leftLine: nil,
                    rightLine: rightIndex + 1
                ))
                rightIndex += 1
            } else if rightIndex >= rightLines.count {
                results.append((
                    content: leftLines[leftIndex],
                    type: .deletion,
                    leftLine: leftIndex + 1,
                    rightLine: nil
                ))
                leftIndex += 1
            } else if leftLines[leftIndex] == rightLines[rightIndex] {
                results.append((
                    content: leftLines[leftIndex],
                    type: .unchanged,
                    leftLine: leftIndex + 1,
                    rightLine: rightIndex + 1
                ))
                leftIndex += 1
                rightIndex += 1
            } else {
                results.append((
                    content: leftLines[leftIndex],
                    type: .deletion,
                    leftLine: leftIndex + 1,
                    rightLine: nil
                ))
                results.append((
                    content: rightLines[rightIndex],
                    type: .addition,
                    leftLine: nil,
                    rightLine: rightIndex + 1
                ))
                leftIndex += 1
                rightIndex += 1
            }
        }
        
        return results
    }
    
    @Test("Compute diff with additions")
    func testDiffAdditions() {
        let leftLines = ["Line 1", "Line 2"]
        let rightLines = ["Line 1", "Line 2", "Line 3"]
        
        let results = computeDiff(leftLines: leftLines, rightLines: rightLines)
        
        #expect(results.count == 3)
        #expect(results[0].type == .unchanged)
        #expect(results[1].type == .unchanged)
        #expect(results[2].type == .addition)
        #expect(results[2].content == "Line 3")
    }
    
    @Test("Compute diff with deletions")
    func testDiffDeletions() {
        let leftLines = ["Line 1", "Line 2", "Line 3"]
        let rightLines = ["Line 1", "Line 3"]
        
        let results = computeDiff(leftLines: leftLines, rightLines: rightLines)
        
        // Line 1 matches
        // Line 2 (left) vs Line 3 (right) - treated as delete + add
        // Line 3 (left) matches nothing - deletion
        #expect(results.count == 4)
        #expect(results[0].type == .unchanged)
        #expect(results[0].content == "Line 1")
        #expect(results[1].type == .deletion)
        #expect(results[1].content == "Line 2")
        #expect(results[2].type == .addition)
        #expect(results[2].content == "Line 3")
        #expect(results[3].type == .deletion)
        #expect(results[3].content == "Line 3")
    }
    
    @Test("Compute diff with modifications")
    func testDiffModifications() {
        let leftLines = ["Hello World"]
        let rightLines = ["Hello Universe"]
        
        let results = computeDiff(leftLines: leftLines, rightLines: rightLines)
        
        #expect(results.count == 2)
        #expect(results[0].type == .deletion)
        #expect(results[0].content == "Hello World")
        #expect(results[1].type == .addition)
        #expect(results[1].content == "Hello Universe")
    }
    
    @Test("Handle identical texts")
    func testIdenticalTexts() {
        let lines = ["Line 1", "Line 2", "Line 3"]
        
        let results = computeDiff(leftLines: lines, rightLines: lines)
        
        #expect(results.count == 3)
        #expect(results.allSatisfy { $0.type == .unchanged })
    }
    
    @Test("Handle empty texts")
    func testEmptyTexts() {
        let results = computeDiff(leftLines: [], rightLines: [])
        
        #expect(results.isEmpty)
    }
    
    @Test("Handle one empty text")
    func testOneEmptyText() {
        let lines = ["Line 1", "Line 2"]
        
        let results = computeDiff(leftLines: lines, rightLines: [])
        
        #expect(results.count == 2)
        #expect(results.allSatisfy { $0.type == .deletion })
    }
    
    @Test("Verify line numbers")
    func testLineNumbers() {
        let leftLines = ["A", "B", "C"]
        let rightLines = ["A", "D", "C"]
        
        let results = computeDiff(leftLines: leftLines, rightLines: rightLines)
        
        // First line unchanged
        #expect(results[0].leftLine == 1)
        #expect(results[0].rightLine == 1)
        
        // B deleted from position 2
        #expect(results[1].type == .deletion)
        #expect(results[1].leftLine == 2)
        #expect(results[1].rightLine == nil)
        
        // D added at position 2
        #expect(results[2].type == .addition)
        #expect(results[2].leftLine == nil)
        #expect(results[2].rightLine == 2)
    }
}

// MARK: - Tool Enum Tests

struct ToolEnumTests {
    
    @Test("All tools are available")
    func testAllToolsAvailable() {
        let allTools = Tool.allCases
        
        #expect(allTools.count == 3)
        #expect(allTools.contains(.urlEncoderDecoder))
        #expect(allTools.contains(.jsonFormatter))
        #expect(allTools.contains(.diffMatcher))
    }
    
    @Test("Tool icons are correct")
    func testToolIcons() {
        #expect(Tool.urlEncoderDecoder.icon == "link")
        #expect(Tool.jsonFormatter.icon == "curlybraces")
        #expect(Tool.diffMatcher.icon == "arrow.triangle.branch")
    }
    
    @Test("Tool display names")
    func testToolDisplayNames() {
        #expect(Tool.urlEncoderDecoder.rawValue == "URL Encoder/Decoder")
        #expect(Tool.jsonFormatter.rawValue == "JSON Formatter")
        #expect(Tool.diffMatcher.rawValue == "Diff Matcher")
    }
}

// MARK: - JSON Node View Tests

struct JSONNodeTests {
    
    @Test("Identify JSON value types")
    func testJSONValueTypes() {
        let string = "test" as Any
        let number = 42 as Any
        let bool = true as Any
        let null = NSNull() as Any
        let array = [1, 2, 3] as Any
        let dict = ["key": "value"] as Any
        
        #expect(string is String)
        #expect(number is NSNumber)
        #expect(bool is Bool)
        #expect(null is NSNull)
        #expect(array is [Any])
        #expect(dict is [String: Any])
    }
    
    @Test("Format JSON collection counts")
    func testCollectionCounts() {
        let array = [1, 2, 3]
        let dict = ["a": 1, "b": 2, "c": 3]
        
        #expect(array.count == 3)
        #expect(dict.count == 3)
        
        // Test formatting
        let arrayFormat = "[\(array.count)]"
        let dictFormat = "{\(dict.count)}"
        
        #expect(arrayFormat == "[3]")
        #expect(dictFormat == "{3}")
    }
}