# Ed-Toolkit

A comprehensive suite of developer tools for macOS built with SwiftUI. Ed-Toolkit provides essential utilities for developers with full accessibility support and multi-language localization.

## Features

### 🔗 URL Encoder/Decoder
- Real-time URL encoding and decoding
- Support for special characters and Unicode
- Keyboard shortcuts (⌘E for encode, ⌘D for decode)
- Copy-paste friendly interface

### 📋 JSON Formatter & Viewer
- Interactive JSON tree structure visualization
- Real-time parsing and validation
- Expandable/collapsible nodes
- Type-aware syntax highlighting
- Error reporting with helpful messages

### 📊 Diff Matcher
- Side-by-side text comparison
- Line-by-line difference highlighting
- Color-coded additions and deletions
- Statistics and summary information
- Line number tracking

## Accessibility

Ed-Toolkit is built with accessibility as a core principle:

### ♿ VoiceOver Support
- Complete screen reader integration
- Descriptive labels and hints for all interactive elements
- Context-aware announcements and feedback

### ⌨️ Keyboard Navigation
- Full keyboard support with intuitive shortcuts
- Smart focus management to prevent keyboard traps
- Custom escape routes from text editors
- Logical tab order throughout the interface

### 🌍 Multi-Language Support
- Available in English, Spanish, and Hindi
- Proper localization for all UI elements and accessibility features
- Devanagari script support for Hindi

### 🎯 Focus Management
- Prevents keyboard navigation traps
- Clear visual focus indicators
- Automatic focus on primary input fields

## System Requirements

- **macOS**: 14.6 or later
- **Architecture**: Apple Silicon or Intel processor
- **Storage**: 50 MB of available space

## Installation

1. Download the latest release from the releases page
2. Open the `.dmg` file
3. Drag Ed-Toolkit to your Applications folder
4. Launch from Applications or Spotlight

## Development

### Prerequisites

- Xcode 15.0 or later
- macOS 14.6 or later for development

### Building the Project

```bash
# Clone the repository
git clone <repository-url>
cd Ed-Toolkit

# Open in Xcode
open Ed-Toolkit.xcodeproj

# Build for macOS
xcodebuild -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit -destination 'platform=macOS' build

# Build for iOS Simulator
xcodebuild -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit -destination 'platform=iOS Simulator,name=iPhone 15' build
```

### Running Tests

```bash
# Run all tests
xcodebuild test -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test
xcodebuild test -project Ed-Toolkit.xcodeproj -scheme Ed-Toolkit -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Ed-ToolkitTests
```

## Project Structure

```
Ed-Toolkit/
├── Ed-Toolkit/                    # Main application source code
│   ├── Ed_ToolkitApp.swift       # App entry point
│   ├── ContentView.swift         # Main view controller
│   ├── ToolsDashboardView.swift  # Dashboard for tool selection
│   ├── URLEncoderDecoderView.swift # URL encoding/decoding tool
│   ├── JSONFormatterView.swift   # JSON formatter and viewer
│   ├── DiffMatcherView.swift     # Text comparison tool
│   ├── UIModifiers/              # Custom SwiftUI modifiers
│   │   └── AccessibilityModifiers.swift # Accessibility helpers
│   ├── Localization/             # Internationalization files
│   │   ├── LocalizationHelper.swift # Localization utilities
│   │   ├── en.lproj/             # English translations
│   │   ├── es.lproj/             # Spanish translations
│   │   └── hi.lproj/             # Hindi translations
│   └── Assets.xcassets/          # App icons and assets
├── Ed-ToolkitTests/              # Unit tests (Swift Testing)
└── Ed-ToolkitUITests/            # UI tests (XCTest)
```

## Testing

The project uses two testing frameworks:

### Unit Tests (Swift Testing)
- Uses modern `@Test` attributes and `#expect()` assertions
- Tests core functionality like JSON parsing, URL encoding, and diff algorithms
- Located in `Ed-ToolkitTests/`

### UI Tests (XCTest)
- Uses `XCUIApplication` for UI automation
- Tests user interactions and accessibility features
- Located in `Ed-ToolkitUITests/`

### Test Coverage
- JSON parsing (valid/invalid inputs, nested structures)
- URL encoding/decoding (special characters, Unicode, edge cases)
- Diff algorithm (additions, deletions, modifications)
- Accessibility features and keyboard navigation
- Multi-language support

## Keyboard Shortcuts

### Global Shortcuts
- **⌘1**: URL Encoder/Decoder
- **⌘2**: JSON Formatter
- **⌘3**: Diff Matcher

### URL Encoder/Decoder
- **⌘E**: Encode text
- **⌘D**: Decode text
- **⌘M**: Switch between encode/decode modes
- **⌘R**: Switch mode and process immediately

### JSON Formatter
- **⌘F**: Format JSON
- **⌘K**: Clear input

### Diff Matcher
- **⌘R**: Compare texts
- **⌘B**: Go back to input view
- **⌘K**: Clear all inputs
- **⌘S**: Swap left and right texts
- **⌘⌥→/⌘⌥←**: Navigate between text areas

## Accessibility Testing

To test accessibility features:

1. **VoiceOver Testing**: Press `⌘F5` to toggle VoiceOver
2. **Keyboard Navigation**: Use Tab and arrow keys to navigate
3. **Focus Management**: Verify all interactive elements are reachable
4. **Screen Reader**: Test all announcements and labels
5. **Keyboard Shortcuts**: Verify all shortcuts work from any context

## Localization

### Supported Languages
- **English** (en) - Base language
- **Spanish** (es) - Complete translation
- **Hindi** (hi) - Complete translation with Devanagari script

### Adding New Languages
1. Create new language folder: `Localization/[language_code].lproj/`
2. Copy `en.lproj/Localizable.strings` to the new folder
3. Translate all string values (keep keys unchanged)
4. Add the language to Xcode project settings
5. Test with the new language selected in System Preferences

## Architecture

Ed-Toolkit is built using:

- **SwiftUI**: Modern declarative UI framework
- **Swift Testing**: Apple's new testing framework for unit tests
- **XCTest**: Traditional framework for UI tests
- **Foundation**: Core data processing and utilities

### Design Principles
- **Accessibility First**: Every feature designed with accessibility in mind
- **Keyboard Friendly**: Complete keyboard navigation support
- **International**: Multi-language support from the ground up
- **Testing**: Comprehensive test coverage for reliability
- **Maintainable**: Clear code structure and documentation

## Support

For support, feature requests, or bug reports, please visit our website or contact us directly.

## Acknowledgments

Built with accessibility and internationalization as core principles to ensure all developers can use these essential tools effectively.
