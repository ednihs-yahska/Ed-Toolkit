//
//  JSONParserTests.swift
//  Ed-ToolkitTests
//
//  Created by Akshay Shinde on 6/24/25.
//

import Testing
@testable import Ed_Toolkit
import Foundation

struct JSONParserTests {
    
    // MARK: - Basic JSON Parsing Tests
    
    @Test("Parse basic object with quoted keys")
    func testBasicObject() throws {
        let parser = JSONParser()
        let json = """
        {
            "name": "John",
            "age": 30,
            "active": true
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["name"] as? String == "John")
        #expect(result["age"] as? Int == 30)
        #expect(result["active"] as? Bool == true)
    }
    
    @Test("Parse basic array")
    func testBasicArray() throws {
        let parser = JSONParser()
        let json = "[1, 2, 3, \"hello\", true, null]"
        
        let result = try parser.parse(json) as! [Any]
        
        #expect(result.count == 6)
        #expect(result[0] as? Int == 1)
        #expect(result[3] as? String == "hello")
        #expect(result[4] as? Bool == true)
        #expect(result[5] is NSNull)
    }
    
    // MARK: - Quote Normalization Tests
    
    @Test("Convert smart quotes to straight quotes")
    func testSmartQuoteConversion() throws {
        let parser = JSONParser()
        let json = """
        {
            "name": "John",
            "message": "Hello "world""
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["name"] as? String == "John")
        #expect(result["message"] as? String == "Hello \"world\"")
    }
    
    @Test("Convert single quotes to double quotes")
    func testSingleQuoteConversion() throws {
        let parser = JSONParser()
        let json = """
        {
            'name': 'John',
            'age': 30
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["name"] as? String == "John")
        #expect(result["age"] as? Int == 30)
    }
    
    @Test("Handle mixed quote types")
    func testMixedQuotes() throws {
        let parser = JSONParser()
        let json = """
        {
            'name': "John",
            "message": 'Hello world',
            'active': true
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["name"] as? String == "John")
        #expect(result["message"] as? String == "Hello world")
        #expect(result["active"] as? Bool == true)
    }
    
    // MARK: - Unquoted Keys Tests
    
    @Test("Parse unquoted keys")
    func testUnquotedKeys() throws {
        let parser = JSONParser()
        let json = """
        {
            name: "John",
            age: 30,
            active: true
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["name"] as? String == "John")
        #expect(result["age"] as? Int == 30)
        #expect(result["active"] as? Bool == true)
    }
    
    @Test("Parse mixed quoted and unquoted keys")
    func testMixedKeyQuoting() throws {
        let parser = JSONParser()
        let json = """
        {
            name: "John",
            "age": 30,
            'city': "New York",
            active: true
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["name"] as? String == "John")
        #expect(result["age"] as? Int == 30)
        #expect(result["city"] as? String == "New York")
        #expect(result["active"] as? Bool == true)
    }
    
    // MARK: - Complex Structure Tests
    
    @Test("Parse nested objects with flexible formatting")
    func testNestedObjects() throws {
        let parser = JSONParser()
        let json = """
        {
            user: {
                name: "John",
                'profile': {
                    "age": 30,
                    address: {
                        street: "123 Main St",
                        'city': "New York"
                    }
                }
            }
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        let user = result["user"] as! [String: Any]
        let profile = user["profile"] as! [String: Any]
        let address = profile["address"] as! [String: Any]
        
        #expect(user["name"] as? String == "John")
        #expect(profile["age"] as? Int == 30)
        #expect(address["street"] as? String == "123 Main St")
        #expect(address["city"] as? String == "New York")
    }
    
    @Test("Parse arrays with nested objects")
    func testArraysWithObjects() throws {
        let parser = JSONParser()
        let json = """
        {
            users: [
                {name: "John", age: 30},
                {'name': "Jane", "age": 25},
                {"name": 'Bob', age: 35}
            ]
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        let users = result["users"] as! [[String: Any]]
        
        #expect(users.count == 3)
        #expect(users[0]["name"] as? String == "John")
        #expect(users[1]["name"] as? String == "Jane")
        #expect(users[2]["name"] as? String == "Bob")
    }
    
    // MARK: - Number Parsing Tests
    
    @Test("Parse various number formats")
    func testNumberParsing() throws {
        let parser = JSONParser()
        let json = """
        {
            integer: 42,
            negative: -17,
            float: 3.14,
            scientific: 1.23e-4,
            bigNumber: 1234567890
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["integer"] as? Int == 42)
        #expect(result["negative"] as? Int == -17)
        #expect(result["float"] as? Double == 3.14)
        #expect(result["scientific"] as? Double == 1.23e-4)
        #expect(result["bigNumber"] as? Int == 1234567890)
    }
    
    // MARK: - String Escape Tests
    
    @Test("Parse strings with escape sequences")
    func testStringEscapes() throws {
        let parser = JSONParser()
        let json = """
        {
            "newline": "Hello\\nWorld",
            "tab": "Hello\\tWorld",
            "quote": "Say \\"Hello\\"",
            "backslash": "Path\\\\to\\\\file",
            "unicode": "Unicode: \\u0041\\u0042"
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["newline"] as? String == "Hello\nWorld")
        #expect(result["tab"] as? String == "Hello\tWorld")
        #expect(result["quote"] as? String == "Say \"Hello\"")
        #expect(result["backslash"] as? String == "Path\\to\\file")
        #expect(result["unicode"] as? String == "Unicode: AB")
    }
    
    // MARK: - Edge Cases
    
    @Test("Parse empty object and array")
    func testEmptyContainers() throws {
        let parser = JSONParser()
        
        let emptyObject = try parser.parse("{}") as! [String: Any]
        #expect(emptyObject.isEmpty)
        
        let emptyArray = try parser.parse("[]") as! [Any]
        #expect(emptyArray.isEmpty)
    }
    
    @Test("Handle whitespace")
    func testWhitespace() throws {
        let parser = JSONParser()
        let json = """
        
        {
            
            name   :   "John"   ,
            
            age    :    30
            
        }
        
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["name"] as? String == "John")
        #expect(result["age"] as? Int == 30)
    }
    
    // MARK: - Error Handling Tests
    
    @Test("Handle invalid JSON syntax")
    func testInvalidJSON() {
        let parser = JSONParser()
        
        #expect(throws: JSONParseError.self) {
            try parser.parse("{name: John}")  // Missing quotes around string value
        }
        
        #expect(throws: JSONParseError.self) {
            try parser.parse("{name: 'John' age: 30}")  // Missing comma
        }
        
        #expect(throws: JSONParseError.self) {
            try parser.parse("{name: 'John',}")  // Trailing comma
        }
    }
    
    @Test("Handle empty input")
    func testEmptyInput() {
        let parser = JSONParser()
        
        #expect(throws: JSONParseError.emptyInput) {
            try parser.parse("")
        }
        
        #expect(throws: JSONParseError.emptyInput) {
            try parser.parse("   ")
        }
    }
    
    @Test("Handle duplicate keys")
    func testDuplicateKeys() {
        let parser = JSONParser()
        
        #expect(throws: JSONParseError.self) {
            try parser.parse("""
            {
                name: "John",
                name: "Jane"
            }
            """)
        }
    }
    
    // MARK: - Performance Tests
    
    @Test("Parse large nested structure")
    func testLargeStructure() throws {
        let parser = JSONParser()
        
        // Generate a large nested JSON structure
        var json = "{"
        for i in 0..<100 {
            json += "key\(i): {value: \(i), nested: {data: 'item\(i)'}},"
        }
        json.removeLast() // Remove trailing comma
        json += "}"
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result.count == 100)
        
        let firstItem = result["key0"] as! [String: Any]
        #expect(firstItem["value"] as? Int == 0)
        
        let lastItem = result["key99"] as! [String: Any]
        #expect(lastItem["value"] as? Int == 99)
    }
    
    // MARK: - JavaScript Object Notation Compatibility
    
    @Test("Parse JavaScript-style object notation")
    func testJavaScriptCompatibility() throws {
        let parser = JSONParser()
        let json = """
        {
            name: 'John Doe',
            age: 30,
            hobbies: ['reading', 'coding', 'gaming'],
            address: {
                street: '123 Main St',
                city: 'New York',
                coordinates: {
                    lat: 40.7128,
                    lng: -74.0060
                }
            },
            active: true,
            avatar: null
        }
        """
        
        let result = try parser.parse(json) as! [String: Any]
        
        #expect(result["name"] as? String == "John Doe")
        #expect(result["age"] as? Int == 30)
        #expect(result["active"] as? Bool == true)
        #expect(result["avatar"] is NSNull)
        
        let hobbies = result["hobbies"] as! [String]
        #expect(hobbies == ["reading", "coding", "gaming"])
        
        let address = result["address"] as! [String: Any]
        #expect(address["street"] as? String == "123 Main St")
        #expect(address["city"] as? String == "New York")
        
        let coordinates = address["coordinates"] as! [String: Any]
        #expect(coordinates["lat"] as? Double == 40.7128)
        #expect(coordinates["lng"] as? Double == -74.0060)
    }
}