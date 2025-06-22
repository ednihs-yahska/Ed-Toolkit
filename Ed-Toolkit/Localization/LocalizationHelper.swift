//
//  LocalizationHelper.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/22/25.
//

import Foundation

// MARK: - Localization Helper
extension String {
    /// Returns a localized string using the key as the identifier
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns a localized string with formatted arguments
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

// MARK: - URL Encoder/Decoder Localized Strings
struct URLEncoderDecoderStrings {
    // MARK: - UI Labels
    static let title = "url_encoder_decoder.title".localized
    static let inputLabel = "url_encoder_decoder.input_label".localized
    static let outputLabel = "url_encoder_decoder.output_label".localized
    static let modeLabel = "url_encoder_decoder.mode_label".localized
    static let encode = "url_encoder_decoder.encode".localized
    static let decode = "url_encoder_decoder.decode".localized
    
    // MARK: - Help Text
    static let shortcutsHelp = "url_encoder_decoder.shortcuts_help".localized
    static let shortcutsHelpAccessibility = "url_encoder_decoder.shortcuts_help_accessibility".localized
    
    // MARK: - Accessibility Labels
    struct Accessibility {
        static let title = "url_encoder_decoder.accessibility.title".localized
        static let shortcutsHelp = "url_encoder_decoder.accessibility.shortcuts_help".localized
        static let modePicker = "url_encoder_decoder.accessibility.mode_picker".localized
        static let inputLabel = "url_encoder_decoder.accessibility.input_label".localized
        static let outputLabel = "url_encoder_decoder.accessibility.output_label".localized
        static let mainView = "url_encoder_decoder.accessibility.main_view".localized
        
        // MARK: - Hints
        static let modeHint = "url_encoder_decoder.accessibility.mode_hint".localized
        static let inputHintEncode = "url_encoder_decoder.accessibility.input_hint_encode".localized
        static let inputHintDecode = "url_encoder_decoder.accessibility.input_hint_decode".localized
        static let processHintEncode = "url_encoder_decoder.accessibility.process_hint_encode".localized
        static let processHintDecode = "url_encoder_decoder.accessibility.process_hint_decode".localized
        static let outputHint = "url_encoder_decoder.accessibility.output_hint".localized
        
        // MARK: - Dynamic Labels
        static let textToEncode = "url_encoder_decoder.accessibility.text_to_encode".localized
        static let textToDecode = "url_encoder_decoder.accessibility.text_to_decode".localized
        static let encodedResult = "url_encoder_decoder.accessibility.encoded_result".localized
        static let decodedResult = "url_encoder_decoder.accessibility.decoded_result".localized
        static let encodeButton = "url_encoder_decoder.accessibility.encode_button".localized
        static let decodeButton = "url_encoder_decoder.accessibility.decode_button".localized
        static let noOutput = "url_encoder_decoder.accessibility.no_output".localized
        
        // MARK: - Actions
        static let showShortcuts = "url_encoder_decoder.action.show_shortcuts".localized
        static let repeatShortcuts = "url_encoder_decoder.action.repeat_shortcuts".localized
        static let helpInfo = "url_encoder_decoder.accessibility.help_info".localized
        static let shortcutsAvailable = "url_encoder_decoder.accessibility.shortcuts_available".localized
    }
    
    // MARK: - Status Messages
    struct Status {
        static let switchedToEncode = "url_encoder_decoder.status.switched_to_encode".localized
        static let switchedToDecode = "url_encoder_decoder.status.switched_to_decode".localized
        static let encodingFailed = "url_encoder_decoder.status.encoding_failed".localized
        static let decodingFailed = "url_encoder_decoder.status.decoding_failed".localized
        static let noInput = "url_encoder_decoder.status.no_input".localized
        
        static func encodedSuccess(characterCount: Int) -> String {
            return "url_encoder_decoder.status.encoded_success".localized(with: characterCount)
        }
        
        static func decodedSuccess(characterCount: Int) -> String {
            return "url_encoder_decoder.status.decoded_success".localized(with: characterCount)
        }
    }
    
    // MARK: - Button Labels
    static let switchMode = "url_encoder_decoder.switch_mode".localized
    static let switchAndProcess = "url_encoder_decoder.switch_and_process".localized
}

// MARK: - Diff Matcher Localized Strings
struct DiffMatcherStrings {
    // MARK: - UI Labels
    static let title = "diff_matcher.title".localized
    static let subtitle = "diff_matcher.subtitle".localized
    static let originalText = "diff_matcher.original_text".localized
    static let modifiedText = "diff_matcher.modified_text".localized
    static let compare = "diff_matcher.compare".localized
    static let backToInput = "diff_matcher.back_to_input".localized
    
    // MARK: - Statistics
    static let additions = "diff_matcher.additions".localized
    static let deletions = "diff_matcher.deletions".localized
    
    // MARK: - Accessibility Labels
    struct Accessibility {
        static let title = "diff_matcher.accessibility.title".localized
        static let subtitle = "diff_matcher.accessibility.subtitle".localized
        static let originalTextEditor = "diff_matcher.accessibility.original_text_editor".localized
        static let modifiedTextEditor = "diff_matcher.accessibility.modified_text_editor".localized
        static let compareButton = "diff_matcher.accessibility.compare_button".localized
        static let backButton = "diff_matcher.accessibility.back_button".localized
        static let resultsView = "diff_matcher.accessibility.results_view".localized
        static let diffLine = "diff_matcher.accessibility.diff_line".localized
        static let mainView = "diff_matcher.accessibility.main_view".localized
        
        // MARK: - Hints
        static let originalTextHint = "diff_matcher.accessibility.original_text_hint".localized
        static let modifiedTextHint = "diff_matcher.accessibility.modified_text_hint".localized
        static let compareHint = "diff_matcher.accessibility.compare_hint".localized
        static let backHint = "diff_matcher.accessibility.back_hint".localized
        static let resultsHint = "diff_matcher.accessibility.results_hint".localized
        
        // MARK: - Status Messages
        static let noChanges = "diff_matcher.accessibility.no_changes".localized
        static let changesFound = "diff_matcher.accessibility.changes_found".localized
        static let emptyInput = "diff_matcher.accessibility.empty_input".localized
        static let returnedToInput = "diff_matcher.accessibility.returned_to_input".localized
        static let allTextCleared = "diff_matcher.accessibility.all_text_cleared".localized
        static let textsSwapped = "diff_matcher.accessibility.texts_swapped".localized
        
        // MARK: - Keyboard Shortcuts
        static let keyboardShortcuts = "diff_matcher.accessibility.keyboard_shortcuts".localized
    }
    
    // MARK: - Dynamic Content
    static func additionsCount(_ count: Int) -> String {
        return "diff_matcher.additions_count".localized(with: count)
    }
    
    static func deletionsCount(_ count: Int) -> String {
        return "diff_matcher.deletions_count".localized(with: count)
    }
    
    static func diffSummary(additions: Int, deletions: Int) -> String {
        return "diff_matcher.diff_summary".localized(with: additions, deletions)
    }
}