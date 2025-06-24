//
//  PlainTextEditor.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/24/25.
//

import SwiftUI
import AppKit

struct PlainTextEditor: NSViewRepresentable {
    @Binding var text: String
    var font: NSFont = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
    var isEditable: Bool = true
    var placeholderText: String = ""
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()
        
        // Configure scroll view
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = false
        scrollView.borderType = .noBorder
        
        // Configure text view
        textView.isEditable = isEditable
        textView.isRichText = false
        textView.font = font
        textView.textColor = NSColor.textColor
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.insertionPointColor = NSColor.textColor
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isGrammarCheckingEnabled = false
        textView.isContinuousSpellCheckingEnabled = false
        textView.isAutomaticLinkDetectionEnabled = false
        textView.isAutomaticDataDetectionEnabled = false
        textView.isAutomaticTextCompletionEnabled = false
        textView.usesInspectorBar = false
        textView.usesFindBar = true
        textView.isIncrementalSearchingEnabled = true
        
        // Set up text container
        textView.textContainer?.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        // Add padding around text content
        textView.textContainerInset = NSSize(width: 8, height: 8)
        
        // Set delegate
        textView.delegate = context.coordinator
        
        // Set initial text
        textView.string = text
        
        // Configure placeholder if provided
        if !placeholderText.isEmpty && text.isEmpty {
            setPlaceholder(textView: textView, placeholder: placeholderText)
        }
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        
        // Update text if it differs from the current content
        if textView.string != text {
            textView.string = text
        }
        
        // Update font if needed
        if textView.font != font {
            textView.font = font
        }
        
        // Update editability
        textView.isEditable = isEditable
        
        // Ensure padding is maintained
        textView.textContainerInset = NSSize(width: 8, height: 8)
        
        // Handle placeholder
        if !placeholderText.isEmpty {
            if text.isEmpty {
                setPlaceholder(textView: textView, placeholder: placeholderText)
            } else {
                clearPlaceholder(textView: textView)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func setPlaceholder(textView: NSTextView, placeholder: String) {
        textView.string = ""
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.placeholderTextColor,
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        textView.textStorage?.setAttributedString(attributedPlaceholder)
    }
    
    private func clearPlaceholder(textView: NSTextView) {
        if textView.textColor == NSColor.placeholderTextColor {
            textView.string = ""
            textView.textColor = NSColor.textColor
        }
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: PlainTextEditor
        
        init(_ parent: PlainTextEditor) {
            self.parent = parent
            super.init()
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            
            // Handle placeholder behavior
            if !parent.placeholderText.isEmpty {
                if textView.string.isEmpty {
                    parent.setPlaceholder(textView: textView, placeholder: parent.placeholderText)
                } else if textView.textColor == NSColor.placeholderTextColor {
                    parent.clearPlaceholder(textView: textView)
                }
            }
            
            // Update binding only if text actually changed and it's not placeholder text
            if textView.textColor != NSColor.placeholderTextColor {
                DispatchQueue.main.async {
                    self.parent.text = textView.string
                }
            }
        }
        
        func textViewDidBeginEditing(_ textView: NSTextView) {
            // Clear placeholder when editing begins
            if !parent.placeholderText.isEmpty && textView.textColor == NSColor.placeholderTextColor {
                parent.clearPlaceholder(textView: textView)
            }
        }
        
        func textViewDidEndEditing(_ textView: NSTextView) {
            // Show placeholder if text is empty
            if !parent.placeholderText.isEmpty && textView.string.isEmpty {
                parent.setPlaceholder(textView: textView, placeholder: parent.placeholderText)
            }
        }
    }
}

// MARK: - Convenience Initializers

extension PlainTextEditor {
    /// Creates a PlainTextEditor with monospaced font for code editing
    static func code(text: Binding<String>, placeholder: String = "") -> PlainTextEditor {
        PlainTextEditor(
            text: text,
            font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular),
            placeholderText: placeholder
        )
    }
    
    /// Creates a read-only PlainTextEditor for displaying formatted text
    static func readOnly(text: Binding<String>, font: NSFont? = nil) -> PlainTextEditor {
        PlainTextEditor(
            text: text,
            font: font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize),
            isEditable: false
        )
    }
}