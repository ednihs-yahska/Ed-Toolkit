# Changelog

All notable changes to Ed-Toolkit will be documented in this file.

## [2025-06-24] - JSON Parser and UI Improvements

### Added
- **Custom JSON Parser** (`JSONParser.swift`): A flexible JSON parser that supports JavaScript-style notation
  - Converts all quote types (smart quotes, single quotes) to standard double quotes
  - Allows unquoted keys in object notation (e.g., `{name: "John"}`)
  - Maintains strict parsing rules for values while being flexible with keys
  - Comprehensive error handling with custom `JSONParseError` types
  - Single-pass parsing for optimal performance
  - Full Unicode support and proper escape sequence handling

- **Custom Error Types** (`JSONParseError.swift`): Detailed error reporting for JSON parsing
  - Specific error cases: invalid characters, unexpected end of input, invalid escapes
  - Position-aware error messages for better debugging
  - Localized error descriptions for user-friendly feedback

- **Comprehensive Test Suite** (`JSONParserTests.swift`): 387 lines of tests covering:
  - Basic JSON parsing (objects, arrays, primitives)
  - Quote normalization (smart quotes → straight quotes)
  - Unquoted key support (JavaScript-style objects)
  - Complex nested structures and mixed formatting
  - Number parsing (integers, floats, scientific notation)
  - String escape sequences and Unicode handling
  - Edge cases (empty containers, whitespace handling)
  - Error conditions and duplicate key detection
  - Performance testing with large structures
  - JavaScript object notation compatibility

- **Custom Text Editor** (`PlainTextEditor.swift`): NSViewRepresentable wrapper for NSTextView
  - Disables smart quote substitution to prevent JSON corruption
  - Added internal padding (8pt top/left) for better visual spacing
  - Proper text binding with real-time updates
  - Code-optimized configuration for JSON editing

### Changed
- **JSON Formatter View**: Removed buggy placeholder text from input field
  - Simplified PlainTextEditor usage by removing placeholder parameter
  - Improved user experience by eliminating confusing placeholder behavior

- **JSON Formatter ViewModel**: Updated to use custom parser with fallback
  - Primary parsing now uses `JSONParser` for flexible JavaScript-style input
  - Falls back to standard `JSONSerialization` for edge cases
  - Enhanced error handling with specific error types
  - Better user feedback through detailed error messages

### Technical Improvements
- **Architecture**: Maintained MVVM pattern throughout all additions
- **Testing**: Comprehensive test coverage with Swift Testing framework
- **Error Handling**: Robust error management with detailed feedback
- **Performance**: Single-pass parsing algorithm for optimal speed
- **Compatibility**: Backward compatible with standard JSON while supporting JavaScript notation
- **Code Quality**: Well-documented code with clear separation of concerns

### Files Modified
- `Ed-Toolkit/Views/JSONFormatterView.swift` - Removed placeholder text
- `Ed-Toolkit/ViewModels/JSONFormatterViewModel.swift` - Integrated custom parser
- `Ed-Toolkit/Views/Components/PlainTextEditor.swift` - Added padding

### Files Added
- `Ed-Toolkit/Models/JSONParser.swift` - Custom JSON parser implementation
- `Ed-Toolkit/Models/JSONParseError.swift` - Custom error types
- `Ed-ToolkitTests/JSONParserTests.swift` - Comprehensive test suite

### Notes
- All changes maintain backward compatibility with existing JSON files
- The custom parser gracefully handles malformed input with helpful error messages
- Performance optimizations ensure smooth operation even with large JSON structures
- Full accessibility support maintained throughout all UI changes