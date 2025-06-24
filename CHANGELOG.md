# Changelog

All notable changes to Ed-Toolkit will be documented in this file.

## [23 Jun 2025] - Additional Improvements

### Added
- **Copy to Clipboard Functionality**: Added copy button to JSON formatter
  - Button appears in JSON Structure header when valid JSON is parsed
  - Copies properly formatted JSON with pretty-printing and sorted keys
  - Keyboard shortcut ⌘⌥C for quick copying (avoids conflict with standard copy)
  - Copy shortcut displayed in view subtitle for discoverability
  - Full accessibility support with descriptive labels and hints
  - Real-time feedback through announcements (success/failure messages)
  - Uses NSPasteboard for reliable clipboard integration

### Changed
- **Replaced TextEditor Components**: Migrated URLEncoderDecoderView and DiffMatcherView to use PlainTextEditor
  - **URLEncoderDecoderView**: Replaced both input and output TextEditor components with PlainTextEditor
    - Input field: Now uses `PlainTextEditor.code()` for consistent monospaced font and smart quote prevention
    - Output field: Now uses `PlainTextEditor.readOnly()` for read-only display with proper text handling
  - **DiffMatcherView**: Replaced both original and modified text TextEditor components with PlainTextEditor
    - Both text areas: Now use `PlainTextEditor.code()` for better technical text editing experience
  - **Benefits**: Consistent behavior across all text editing in the app, prevents smart quote corruption in URLs and diffs
  - **Maintained Features**: All existing accessibility, focus management, keyboard shortcuts, and styling preserved

### Fixed
- **Smart Quote Conversion Bug**: Fixed critical issue in JSONParser where Unicode smart quotes inside string values were not properly escaped
  - Issue: Smart quotes `\u{201C}` and `\u{201D}` were being converted to unescaped straight quotes, creating invalid JSON
  - Example: `"message": "Hello "world""` (invalid) instead of `"message": "Hello \"world\""` (valid)
  - Solution: Added `normalizeSmartQuotesInStrings()` method to properly escape smart quotes inside string values
  - Result: `testSmartQuoteConversion` test now passes, ensuring reliable parsing of documents with smart quotes

### Technical Implementation
- **Clipboard Integration**: Uses NSPasteboard.general for cross-app compatibility
- **JSON Formatting**: Leverages JSONSerialization with .prettyPrinted and .sortedKeys options
- **Smart Quote Fix**: Added context-aware smart quote normalization that:
  - Tracks whether parser is inside a string value using quote state
  - Converts smart quotes to escaped straight quotes (`\"`) when inside strings
  - Maintains proper JSON structure and validity
  - Supports all Unicode smart quote variants (`\u{201C}`, `\u{201D}`, `\u{2018}`, `\u{2019}`, etc.)
- **Error Handling**: Graceful fallback with user feedback for copy failures
- **Accessibility**: Complete VoiceOver support with success/failure announcements
- **Keyboard Shortcuts**: ⌘⌥C shortcut added to existing ⌘K (clear) and ⌘F (format) shortcuts

### Files Modified
- `Ed-Toolkit/Models/JSONParser.swift` - Enhanced quote normalization logic
- `Ed-Toolkit/Views/JSONFormatterView.swift` - Added copy button and updated keyboard shortcut to ⌘⌥C
- `Ed-Toolkit/Views/URLEncoderDecoderView.swift` - Migrated to PlainTextEditor components
- `Ed-Toolkit/Views/DiffMatcherView.swift` - Migrated to PlainTextEditor components
- `Ed-Toolkit/ViewModels/JSONFormatterViewModel.swift` - Added copyFormattedJSON method
- `Ed-Toolkit/Localization/LocalizationHelper.swift` - Added copy functionality strings
- `Ed-Toolkit/Localization/en.lproj/Localizable.strings` - Added English copy translations
- `Ed-Toolkit/Localization/es.lproj/Localizable.strings` - Added Spanish copy translations
- `Ed-Toolkit/Localization/hi.lproj/Localizable.strings` - Added Hindi copy translations

### Notes
- All changes maintain backward compatibility with existing JSON files
- The custom parser gracefully handles malformed input with helpful error messages
- Performance optimizations ensure smooth operation even with large JSON structures
- Full accessibility support maintained throughout all UI changes
- Copy functionality only available when valid JSON is successfully parsed
- Smart quote fix ensures documents copied from word processors parse correctly
