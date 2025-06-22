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