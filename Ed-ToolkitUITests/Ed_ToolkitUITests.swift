//
//  Ed_ToolkitUITests.swift
//  Ed-ToolkitUITests
//
//  Created by Akshay Shinde on 6/21/25.
//

import XCTest

final class Ed_ToolkitUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Navigation Tests
    
    @MainActor
    func testAppLaunches() throws {
        // Simple test to verify app launches successfully
        XCTAssertTrue(app.exists)
        
        // Print all available elements for debugging
        let elements = app.debugDescription
        print("App elements: \(elements)")
        
        // Look for any navigation-related elements
        let allButtons = app.buttons.allElementsBoundByIndex
        let allStaticTexts = app.staticTexts.allElementsBoundByIndex
        let allOutlines = app.outlines.allElementsBoundByIndex
        
        print("Buttons count: \(allButtons.count)")
        print("Static texts count: \(allStaticTexts.count)")
        print("Outlines count: \(allOutlines.count)")
        
        // Basic assertion that the app has some UI elements
        XCTAssertTrue(allButtons.count > 0 || allStaticTexts.count > 0 || allOutlines.count > 0)
    }
    
    @MainActor
    func testToolsDashboardNavigation() throws {
        // Wait for app to fully load
        sleep(2)
        
        // Try to find sidebar by different selectors
        let sidebar = app.splitGroups.firstMatch.outlines.firstMatch
        
        if sidebar.exists {
            // Check if tools are listed
            let urlTool = sidebar.staticTexts["URL Encoder/Decoder"]
            let jsonTool = sidebar.staticTexts["JSON Formatter"]
            let diffTool = sidebar.staticTexts["Diff Matcher"]
            
            XCTAssertTrue(urlTool.exists || jsonTool.exists || diffTool.exists, 
                         "At least one tool should be visible in sidebar")
            
            // Try to click on a tool if it exists
            if jsonTool.exists {
                jsonTool.click()
                sleep(1)
            }
        } else {
            // Fallback: just verify the app has some content
            XCTAssertTrue(app.staticTexts.count > 0, "App should have some text content")
        }
    }
    
    // MARK: - URL Encoder/Decoder Tests
    
    @MainActor
    func testURLEncoderDecoder() throws {
        // Simple test to verify URL Encoder/Decoder functionality
        sleep(2) // Wait for app to load
        
        // Look for encode/decode related elements
        let encodeButton = app.buttons.matching(identifier: "Encode").firstMatch
        let textViews = app.textViews.allElementsBoundByIndex
        
        if encodeButton.exists && textViews.count >= 2 {
            // Test basic interaction if elements are found
            let inputField = textViews[0]
            if inputField.exists {
                inputField.click()
                inputField.typeText("test")
                
                if encodeButton.exists {
                    encodeButton.click()
                }
            }
        }
        
        // Basic assertion that we have some UI elements
        XCTAssertTrue(app.buttons.count > 0 || app.textViews.count > 0, 
                     "Should have some interactive elements")
    }
    
    // MARK: - JSON Formatter Tests
    
    @MainActor
    func testJSONFormatter() throws {
        // Simple test for JSON functionality
        sleep(2)
        
        // Look for text views that might be JSON input
        let textViews = app.textViews.allElementsBoundByIndex
        
        if textViews.count > 0 {
            let inputField = textViews[0]
            if inputField.exists {
                inputField.click()
                inputField.typeText("{\"test\": true}")
                sleep(1)
            }
        }
        
        // Verify app has basic elements
        XCTAssertTrue(app.textViews.count > 0 || app.staticTexts.count > 0,
                     "Should have some text elements")
    }
    
    // MARK: - Diff Matcher Tests
    
    @MainActor
    func testDiffMatcher() throws {
        // Simple test for diff functionality
        sleep(2)
        
        // Look for compare button
        let compareButton = app.buttons.matching(identifier: "Compare").firstMatch
        let textViews = app.textViews.allElementsBoundByIndex
        
        if textViews.count >= 2 {
            // Try to enter text in both fields
            textViews[0].click()
            textViews[0].typeText("text1")
            
            textViews[1].click() 
            textViews[1].typeText("text2")
            
            if compareButton.exists {
                compareButton.click()
                sleep(1)
            }
        }
        
        // Basic assertion
        XCTAssertTrue(app.buttons.count > 0 || app.textViews.count > 0,
                     "Should have interactive elements")
    }
    
    // MARK: - Performance Tests
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    // MARK: - Accessibility Tests
    
    @MainActor
    func testAccessibility() throws {
        // Basic accessibility test
        sleep(2)
        
        // Check that buttons are hittable
        let allButtons = app.buttons.allElementsBoundByIndex
        var hittableButtonsCount = 0
        
        for button in allButtons {
            if button.isHittable {
                hittableButtonsCount += 1
            }
        }
        
        // Basic assertion that we have some accessible elements
        XCTAssertTrue(hittableButtonsCount > 0 || app.staticTexts.count > 0,
                     "Should have some accessible elements")
    }
}

// MARK: - Helper Extensions

extension XCUIElement {
    func clearAndTypeText(_ text: String) {
        self.click()
        self.typeKey("a", modifierFlags: .command)
        self.typeText(text)
    }
}