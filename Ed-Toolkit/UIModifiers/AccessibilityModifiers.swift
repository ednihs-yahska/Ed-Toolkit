//
//  AccessibilityModifiers.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/22/25.
//

import SwiftUI

// MARK: - Custom Accessibility Modifiers

/// Modifier for page headers with optional hints
struct PageHeaderAccessibility: ViewModifier {
    let label: String
    let hint: String?
    let identifier: String
    
    func body(content: Content) -> some View {
        content
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityIdentifier(identifier)
    }
}

/// Modifier for text input fields with context-aware labels and hints
struct TextInputAccessibility: ViewModifier {
    let label: String
    let hint: String
    let value: String?
    let identifier: String
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityValue(value ?? "")
            .accessibilityIdentifier(identifier)
    }
}

/// Modifier for action buttons with context-aware labels
struct ActionButtonAccessibility: ViewModifier {
    let label: String
    let hint: String
    let identifier: String
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityIdentifier(identifier)
    }
}

/// Modifier for read-only output fields
struct OutputFieldAccessibility: ViewModifier {
    let label: String
    let hint: String
    let value: String
    let identifier: String
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityValue(value.isEmpty ? "No output yet" : value)
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityIdentifier(identifier)
    }
}

/// Modifier for picker/segmented controls
struct PickerAccessibility: ViewModifier {
    let label: String
    let hint: String
    let identifier: String
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityIdentifier(identifier)
    }
}

/// Modifier for hidden decorative text
struct DecorativeTextAccessibility: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accessibilityHidden(true)
    }
}

/// Modifier for main view containers
struct MainViewAccessibility: ViewModifier {
    let label: String
    let identifier: String
    
    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .contain)
            .accessibilityLabel(label)
            .accessibilityIdentifier(identifier)
    }
}

// MARK: - View Extensions

extension View {
    /// Apply page header accessibility with optional hint
    func pageHeaderAccessibility(label: String, hint: String? = nil, identifier: String) -> some View {
        modifier(PageHeaderAccessibility(label: label, hint: hint, identifier: identifier))
    }
    
    /// Apply text input accessibility with context-aware labels
    func textInputAccessibility(label: String, hint: String, value: String? = nil, identifier: String) -> some View {
        modifier(TextInputAccessibility(label: label, hint: hint, value: value, identifier: identifier))
    }
    
    /// Apply action button accessibility
    func actionButtonAccessibility(label: String, hint: String, identifier: String) -> some View {
        modifier(ActionButtonAccessibility(label: label, hint: hint, identifier: identifier))
    }
    
    /// Apply output field accessibility for read-only content
    func outputFieldAccessibility(label: String, hint: String, value: String, identifier: String) -> some View {
        modifier(OutputFieldAccessibility(label: label, hint: hint, value: value, identifier: identifier))
    }
    
    /// Apply picker accessibility
    func pickerAccessibility(label: String, hint: String, identifier: String) -> some View {
        modifier(PickerAccessibility(label: label, hint: hint, identifier: identifier))
    }
    
    /// Mark text as decorative (hidden from accessibility)
    func decorativeTextAccessibility() -> some View {
        modifier(DecorativeTextAccessibility())
    }
    
    /// Apply main view container accessibility
    func mainViewAccessibility(label: String, identifier: String) -> some View {
        modifier(MainViewAccessibility(label: label, identifier: identifier))
    }
}

// MARK: - Convenience Extensions

extension View {
    /// Apply URL Encoder/Decoder specific accessibility patterns
    func urlEncoderInputAccessibility(isEncoding: Bool, pageTitle: String, shortcuts: String) -> some View {
        let label = "\(pageTitle). \(isEncoding ? URLEncoderDecoderStrings.Accessibility.textToEncode : URLEncoderDecoderStrings.Accessibility.textToDecode)"
        let hint = isEncoding ? URLEncoderDecoderStrings.Accessibility.inputHintEncode : URLEncoderDecoderStrings.Accessibility.inputHintDecode
        
        return textInputAccessibility(
            label: label,
            hint: hint,
            value: shortcuts,
            identifier: "URLEncoderDecoder.inputTextEditor"
        )
    }
    
    /// Apply URL Encoder/Decoder output accessibility
    func urlEncoderOutputAccessibility(isEncoding: Bool, outputText: String) -> some View {
        let label = isEncoding ? URLEncoderDecoderStrings.Accessibility.encodedResult : URLEncoderDecoderStrings.Accessibility.decodedResult
        
        return outputFieldAccessibility(
            label: label,
            hint: URLEncoderDecoderStrings.Accessibility.outputHint,
            value: outputText,
            identifier: "URLEncoderDecoder.outputTextEditor"
        )
    }
    
    /// Apply URL Encoder/Decoder process button accessibility
    func urlEncoderProcessButtonAccessibility(isEncoding: Bool) -> some View {
        let label = isEncoding ? URLEncoderDecoderStrings.Accessibility.encodeButton : URLEncoderDecoderStrings.Accessibility.decodeButton
        let hint = isEncoding ? URLEncoderDecoderStrings.Accessibility.processHintEncode : URLEncoderDecoderStrings.Accessibility.processHintDecode
        
        return actionButtonAccessibility(
            label: label,
            hint: hint,
            identifier: "URLEncoderDecoder.processButton"
        )
    }
}