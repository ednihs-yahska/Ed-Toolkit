//
//  URLEncoderDecoderView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/21/25.
//

import SwiftUI

struct URLEncoderDecoderView: View {
    @State private var inputText = ""
    @State private var outputText = ""
    @State private var isEncoding = true
    @State private var lastActionAnnouncement = ""
    @FocusState private var focusedField: FocusedField?
    
    enum FocusedField: Hashable {
        case input
        case output
        case processButton
        case modePicker
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text(URLEncoderDecoderStrings.title)
                    .font(.largeTitle)
                    .pageHeaderAccessibility(
                        label: URLEncoderDecoderStrings.Accessibility.title,
                        hint: URLEncoderDecoderStrings.shortcutsHelpAccessibility,
                        identifier: "URLEncoderDecoder.title"
                    )
                
                Text(URLEncoderDecoderStrings.shortcutsHelp)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .decorativeTextAccessibility()
            }
            .padding()
            .accessibilityElement(children: .contain)
            
            Picker(URLEncoderDecoderStrings.modeLabel, selection: $isEncoding) {
                Text(URLEncoderDecoderStrings.encode).tag(true)
                Text(URLEncoderDecoderStrings.decode).tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .focused($focusedField, equals: .modePicker)
            .pickerAccessibility(
                label: URLEncoderDecoderStrings.Accessibility.modePicker,
                hint: URLEncoderDecoderStrings.Accessibility.modeHint,
                identifier: "URLEncoderDecoder.modePicker"
            )
            
            VStack(alignment: .leading) {
                Text(URLEncoderDecoderStrings.inputLabel)
                    .font(.headline)
                    .accessibilityLabel(URLEncoderDecoderStrings.Accessibility.inputLabel)
                    .accessibilityIdentifier("URLEncoderDecoder.inputLabel")
                TextEditor(text: $inputText)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .focused($focusedField, equals: .input)
                    .urlEncoderInputAccessibility(
                        isEncoding: isEncoding,
                        pageTitle: URLEncoderDecoderStrings.Accessibility.title,
                        shortcuts: URLEncoderDecoderStrings.shortcutsHelpAccessibility
                    )
            }
            .padding(.horizontal)
            .accessibilityElement(children: .combine)
            
            Button(action: processURL) {
                Label(isEncoding ? URLEncoderDecoderStrings.encode : URLEncoderDecoderStrings.decode, systemImage: "arrow.down.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            .focused($focusedField, equals: .processButton)
            .urlEncoderProcessButtonAccessibility(isEncoding: isEncoding)
            .keyboardShortcut(isEncoding ? "e" : "d", modifiers: .command)
            
            VStack(alignment: .leading) {
                Text(URLEncoderDecoderStrings.outputLabel)
                    .font(.headline)
                    .accessibilityLabel(URLEncoderDecoderStrings.Accessibility.outputLabel)
                    .accessibilityIdentifier("URLEncoderDecoder.outputLabel")
                TextEditor(text: .constant(outputText))
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .focused($focusedField, equals: .output)
                    .urlEncoderOutputAccessibility(isEncoding: isEncoding, outputText: outputText)
            }
            .padding(.horizontal)
            .accessibilityElement(children: .combine)
            
            Spacer()
            
            // Hidden buttons for keyboard shortcuts
            HStack {
                Button(URLEncoderDecoderStrings.switchMode) {
                    toggleMode()
                }
                .keyboardShortcut("m", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                
                Button(URLEncoderDecoderStrings.switchAndProcess) {
                    switchAndProcess()
                }
                .keyboardShortcut("r", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
            }
        }
        .padding()
        .mainViewAccessibility(
            label: URLEncoderDecoderStrings.Accessibility.mainView,
            identifier: "URLEncoderDecoder.mainView"
        )
        .onAppear {
            // Set initial focus to input text area
            focusedField = .input
        }
        .accessibilityAction(.default) {
            // This can be triggered by VoiceOver users with a gesture
            lastActionAnnouncement = URLEncoderDecoderStrings.shortcutsHelpAccessibility
        }
        .accessibilityAction(named: URLEncoderDecoderStrings.Accessibility.showShortcuts) {
            lastActionAnnouncement = URLEncoderDecoderStrings.Accessibility.shortcutsAvailable
        }
    }
    
    func toggleMode() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isEncoding.toggle()
        }
        
        // Announce mode change to VoiceOver
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            lastActionAnnouncement = isEncoding ? URLEncoderDecoderStrings.Status.switchedToEncode : URLEncoderDecoderStrings.Status.switchedToDecode
        }
    }
    
    func switchAndProcess() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isEncoding.toggle()
        }
        
        // Process with new mode after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            processURL()
        }
    }
    
    func processURL() {
        if isEncoding {
            outputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        } else {
            outputText = inputText.removingPercentEncoding ?? ""
        }
        
        // Update state for VoiceOver announcement
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let resultLength = outputText.count
            
            if outputText.isEmpty && !inputText.isEmpty {
                lastActionAnnouncement = isEncoding ? URLEncoderDecoderStrings.Status.encodingFailed : URLEncoderDecoderStrings.Status.decodingFailed
            } else if outputText.isEmpty {
                lastActionAnnouncement = URLEncoderDecoderStrings.Status.noInput
            } else {
                lastActionAnnouncement = isEncoding ? 
                    URLEncoderDecoderStrings.Status.encodedSuccess(characterCount: resultLength) :
                    URLEncoderDecoderStrings.Status.decodedSuccess(characterCount: resultLength)
            }
        }
    }
}

#Preview {
    URLEncoderDecoderView()
}
