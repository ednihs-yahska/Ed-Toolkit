# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ed-Toolkit is a SwiftUI-based iOS/macOS application built with Xcode. The project uses Apple's modern Swift Testing framework for unit tests and XCTest for UI tests.

## Common Development Commands

### Building the Project
```bash
# Build for iOS Simulator
xcodebuild -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit -destination 'platform=iOS Simulator,name=iPhone 15' build

# Build for macOS
xcodebuild -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit -destination 'platform=macOS' build

# Clean build folder
xcodebuild -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit clean
```

### Running Tests
```bash
# Run all tests
xcodebuild test -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test
xcodebuild test -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Ed-ToolkitTests/Ed_ToolkitTests/example
```

### Opening in Xcode
```bash
open Ed-Toolkit.xcodeproj
```

## Project Architecture

### Structure
- **Ed-Toolkit/**: Main application source code
  - `Ed_ToolkitApp.swift`: SwiftUI App entry point (@main)
  - `ContentView.swift`: Primary view of the application
  - `ToolsDashboardView.swift`: Dashboard for accessing various tools
  - `JSONFormatterView.swift`: JSON formatter and viewer with interactive tree structure
  - `URLEncoderDecoderView.swift`: URL encoding/decoding utility
  - `DiffMatcherView.swift`: Text comparison tool with diff visualization
  - `Assets.xcassets/`: Application assets and icons
  - `Ed_Toolkit.entitlements`: App capabilities and permissions

- **Ed-ToolkitTests/**: Unit tests using Swift Testing framework
  - Uses `@Test` attributes and `#expect()` assertions

- **Ed-ToolkitUITests/**: UI tests using XCTest framework
  - Uses XCUIApplication for UI automation testing

### Key Technologies
- **SwiftUI**: Modern declarative UI framework
- **Swift Testing**: Apple's new testing framework for unit tests (using `import Testing`)
- **XCTest**: UI testing framework
- **Preview Support**: SwiftUI previews enabled with `#Preview` macro

### Testing Approach
The project uses two testing frameworks:
1. Swift Testing (modern) for unit tests - use `@Test` attribute and `#expect()` for assertions
2. XCTest (traditional) for UI tests - use `XCTAssert` family of assertions

When adding new tests, follow the existing patterns in the respective test directories.

### Test Coverage
Unit tests are implemented for:
- **JSON Parsing**: Valid/invalid JSON, nested structures, empty inputs
- **URL Encoding/Decoding**: Special characters, Unicode, spaces, edge cases
- **Diff Algorithm**: Additions, deletions, modifications, identical texts, line numbering
- **Tool Enumeration**: Tool availability, icons, display names
- **JSON Type Detection**: String, number, boolean, null, array, object identification

Tests focus on the core logic rather than SwiftUI view state, ensuring reliable and maintainable test coverage.

### UI Test Structure
UI tests are implemented in `Ed-ToolkitUITests` using XCTest framework:
- **App Launch Tests**: Verify application launches successfully
- **Navigation Tests**: Test tool selection and view switching
- **Interaction Tests**: Test user interactions with each tool
- **Performance Tests**: Measure app launch performance
- **Accessibility Tests**: Verify UI elements are accessible

Note: UI tests may require app signing and proper test configuration to run successfully in all environments.

## Component Documentation

### JSONFormatterView
A SwiftUI view that provides JSON formatting and visualization capabilities:
- **Input Panel**: Text editor for pasting raw JSON
- **Real-time Parsing**: Automatically parses JSON as you type
- **Tree View**: Interactive hierarchical display of JSON structure
- **Error Handling**: Shows parse errors with helpful messages
- **Type Indicators**: Visual differentiation for strings, numbers, booleans, nulls, objects, and arrays
- **Expandable Nodes**: Click to expand/collapse nested objects and arrays
- **Path Tracking**: Internal path tracking for managing expanded states

Key features:
- Uses `JSONSerialization` for parsing
- Monospaced font for better readability
- Color-coded values by type (strings in green, numbers in orange, etc.)
- Shows element counts for objects and arrays

### URLEncoderDecoderView
A SwiftUI view for URL encoding and decoding operations:
- **Mode Toggle**: Segmented control to switch between encode/decode modes
- **Input/Output Fields**: Separate text editors for input and output
- **One-click Processing**: Button to perform encoding or decoding
- **URL-safe Encoding**: Uses `urlQueryAllowed` character set for encoding
- **Automatic Decoding**: Handles percent-encoded strings

Key features:
- Uses Swift's built-in `addingPercentEncoding` and `removingPercentEncoding`
- Monospaced font for better visibility of encoded characters
- Clean, focused interface for quick URL processing
- Read-only output field to prevent accidental modifications

### DiffMatcherView
A SwiftUI view for comparing two texts and visualizing differences:
- **Split View Interface**: Two side-by-side text editors for original and modified text
- **Diff Visualization**: Color-coded line-by-line comparison
- **Statistics**: Shows count of additions and deletions
- **Line Numbers**: Displays line numbers for both original and modified texts
- **Interactive Results**: Toggle between input and results views

Key features:
- Line-by-line diff algorithm for clear comparison
- Color coding: green for additions, red for deletions, normal for unchanged
- Handles empty lines and maintains proper formatting
- Monospaced font for code-friendly display
- Clean navigation between input and results views