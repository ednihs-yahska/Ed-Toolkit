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
  - `UIModifiers/`: Custom SwiftUI view modifiers
    - `AccessibilityModifiers.swift`: Custom accessibility modifiers and view extensions
  - `Localization/`: Internationalization and localization files
    - `LocalizationHelper.swift`: Helper extension and structured string constants
    - `en.lproj/Localizable.strings`: English localization (base language)
    - `es.lproj/Localizable.strings`: Spanish localization
    - `hi.lproj/Localizable.strings`: Hindi localization
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

## Accessibility Features

The application implements comprehensive accessibility support following Apple's accessibility guidelines:

### URLEncoderDecoderView Accessibility
- **VoiceOver Support**: All interactive elements have descriptive labels and hints
- **Accessibility Labels**: Clear, context-aware descriptions for all UI elements
- **Accessibility Identifiers**: Unique identifiers for UI testing and assistive technologies
- **Keyboard Navigation**: Keyboard shortcuts (⌘E for encode, ⌘D for decode)
- **Dynamic Content**: Output field announces changes with character counts
- **Error Feedback**: Specific announcements for failed operations
- **Semantic Structure**: Proper grouping and traits for logical navigation

### Accessibility Implementation Details
- **Headers**: Main title marked with `.isHeader` trait
- **Input Validation**: Clear feedback for empty or invalid input
- **Result Announcements**: Success/failure messages for VoiceOver users
- **Context-Aware Labels**: Labels change based on encode/decode mode
- **Read-Only Indicators**: Output field clearly marked as non-editable
- **Frequent Updates**: Output marked with `.updatesFrequently` trait

### Keyboard Navigation & TextEditor Escape
**Problem Solved**: TextEditor fields can trap keyboard users who can't exit using Tab key.

**Solution Implemented**:
- **Focus Management**: Complete `@FocusState` implementation for all interactive elements
- **Initial Focus**: View opens with focus on input text area for immediate text entry
- **Keyboard Shortcuts**: Global ⌘E/⌘D shortcuts work from anywhere in the interface
- **Visual Instructions**: On-screen help text explains navigation options
- **Logical Tab Order**: Proper focus flow between elements
- **VoiceOver Integration**: Screen readers can navigate effectively
- **Context-Aware Labels**: Input text area includes page title and keyboard shortcuts in accessibility label

**Navigation Methods for Users**:
1. **Processing Shortcuts**: ⌘E to encode, ⌘D to decode from any field
2. **Mode Switching**: ⌘M to toggle between encode/decode modes
3. **Quick Switch**: ⌘R to switch mode and process immediately
4. **Standard Navigation**: Tab key works normally between non-text elements
5. **Button Focus**: Users can click buttons to trigger actions
6. **VoiceOver**: Full screen reader support with proper announcements

### VoiceOver Help Text Issues Fixed
**Problem**: VoiceOver was not reading keyboard shortcuts help text when elements were grouped.

**Solutions Implemented**:
1. **Title Accessibility Hint**: Keyboard shortcuts information added as accessibility hint to main title
2. **Visual Help Text**: Subtitle remains visible as regular text for sighted users
3. **Simplified Accessibility**: Removed complex button and invisible element approaches
4. **Focused Accessibility**: All help information accessible when VoiceOver focuses on page title

**How VoiceOver Users Can Access Help**:
- **Navigate to title**: VoiceOver will read title with keyboard shortcuts as hint
- **Automatic Announcement**: Shortcuts information provided immediately when title is focused
- **No Extra Navigation**: Users don't need to find separate help elements

### Custom Accessibility Modifiers

**Location**: `UIModifiers/AccessibilityModifiers.swift`

The application uses custom SwiftUI view modifiers to ensure consistent and maintainable accessibility implementation:

#### **Generic Modifiers**:
- **`pageHeaderAccessibility`**: For page titles with optional hints
- **`textInputAccessibility`**: For text input fields with context-aware labels
- **`actionButtonAccessibility`**: For action buttons with descriptive hints
- **`outputFieldAccessibility`**: For read-only output fields with update traits
- **`pickerAccessibility`**: For picker/segmented controls
- **`decorativeTextAccessibility`**: For hiding decorative text from VoiceOver
- **`mainViewAccessibility`**: For main view containers

#### **URL Encoder/Decoder Specific Modifiers**:
- **`urlEncoderInputAccessibility`**: Combines page title, context, and shortcuts for input field
- **`urlEncoderOutputAccessibility`**: Handles dynamic output labeling based on mode
- **`urlEncoderProcessButtonAccessibility`**: Context-aware button accessibility

#### **Benefits**:
- **Consistency**: All accessibility patterns standardized across the app
- **Maintainability**: Single place to update accessibility behavior
- **Reusability**: Easy to apply the same patterns to new views
- **Type Safety**: Compile-time validation of accessibility parameters

#### **Usage Example**:
```swift
Text("Page Title")
    .pageHeaderAccessibility(
        label: "Accessible Title",
        hint: "Additional context for screen readers",
        identifier: "unique.identifier"
    )

TextEditor(text: $inputText)
    .urlEncoderInputAccessibility(
        isEncoding: isEncoding,
        pageTitle: pageTitle,
        shortcuts: shortcutsHelp
    )
```

### Testing Accessibility
- Use VoiceOver (⌘F5) to test screen reader functionality
- **Test Title with Hint**: Navigate to page title and verify VoiceOver reads keyboard shortcuts as hint
- Use Accessibility Inspector to verify element properties
- Test keyboard navigation with Tab and arrow keys
- Test all keyboard shortcuts: ⌘E/⌘D (process), ⌘M (switch mode), ⌘R (switch & process)
- Verify users can escape TextEditor fields using keyboard shortcuts
- Test mode switching with smooth animations and VoiceOver announcements
- Verify all interactive elements are properly labeled and accessible
- **Test Initial Focus**: Verify view opens with focus on input text area
- **Test Context Labels**: When focused on input, VoiceOver should announce page title and keyboard shortcuts
- **Test Custom Modifiers**: Verify all custom accessibility modifiers work correctly

## Localization

The application is fully prepared for internationalization with comprehensive localization support:

### Localization Structure
- **Localization Directory**: All localization files organized in `Ed-Toolkit/Localization/`
  - **LocalizationHelper.swift**: Helper extension and structured string constants
  - **en.lproj/Localizable.strings**: English localization (base language)
  - **es.lproj/Localizable.strings**: Spanish localization
  - **hi.lproj/Localizable.strings**: Hindi localization
- **Language Support**: Proper iOS/macOS localization structure with language-specific `.lproj` directories

### URLEncoderDecoderView Localization
All text strings have been extracted and localized:
- **UI Labels**: Title, input/output labels, button text, mode picker
- **Accessibility Content**: All VoiceOver labels, hints, and announcements
- **Help Text**: Keyboard shortcuts and instructions
- **Status Messages**: Success/failure announcements with dynamic content
- **Dynamic Strings**: Character counts and formatted messages

### Localization Implementation
```swift
// Simple strings
Text(URLEncoderDecoderStrings.title)

// Dynamic accessibility labels
.accessibilityLabel(isEncoding ? URLEncoderDecoderStrings.Accessibility.textToEncode : URLEncoderDecoderStrings.Accessibility.textToDecode)

// Formatted strings with parameters
URLEncoderDecoderStrings.Status.encodedSuccess(characterCount: resultLength)
```

### Adding New Languages
1. Create new language folder: `Localization/[language_code].lproj/` (e.g., `hi.lproj/` for Hindi)
2. Copy `en.lproj/Localizable.strings` to new folder
3. Translate all string values (keep keys unchanged)
4. Add language to Xcode project settings
5. Test with language selection in System Preferences

### Supported Languages
- **English** (`en`) - Base language
- **Spanish** (`es`) - Complete translation
- **Hindi** (`hi`) - Complete translation with Devanagari script
- **Extensible** - Easy to add more languages using the same pattern

### Benefits
- **Maintainable**: All strings centralized in one location
- **Accessible**: Full VoiceOver support in all languages
- **Type-Safe**: Compile-time string validation through helper structures
- **Scalable**: Easy to add new languages and update existing translations

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