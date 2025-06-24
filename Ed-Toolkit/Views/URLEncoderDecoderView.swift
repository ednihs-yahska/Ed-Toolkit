//
//  URLEncoderDecoderView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/21/25.
//

import SwiftUI

struct URLEncoderDecoderView: View {
    @StateObject private var viewModel = URLEncoderDecoderViewModel()
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
            
            Picker(URLEncoderDecoderStrings.modeLabel, selection: $viewModel.isEncoding) {
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
                PlainTextEditor.code(text: $viewModel.inputText)
                    .frame(minHeight: 100)
                    .focused($focusedField, equals: .input)
                    .urlEncoderInputAccessibility(
                        isEncoding: viewModel.isEncoding,
                        pageTitle: URLEncoderDecoderStrings.Accessibility.title,
                        shortcuts: URLEncoderDecoderStrings.shortcutsHelpAccessibility
                    )
            }
            .padding(.horizontal)
            .accessibilityElement(children: .combine)
            
            Button(action: viewModel.processText) {
                Label(viewModel.isEncoding ? URLEncoderDecoderStrings.encode : URLEncoderDecoderStrings.decode, systemImage: "arrow.down.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            .focused($focusedField, equals: .processButton)
            .urlEncoderProcessButtonAccessibility(isEncoding: viewModel.isEncoding)
            .keyboardShortcut(viewModel.isEncoding ? "e" : "d", modifiers: .command)
            
            VStack(alignment: .leading) {
                Text(URLEncoderDecoderStrings.outputLabel)
                    .font(.headline)
                    .accessibilityLabel(URLEncoderDecoderStrings.Accessibility.outputLabel)
                    .accessibilityIdentifier("URLEncoderDecoder.outputLabel")
                PlainTextEditor.readOnly(text: .constant(viewModel.outputText))
                    .frame(minHeight: 100)
                    .focused($focusedField, equals: .output)
                    .urlEncoderOutputAccessibility(isEncoding: viewModel.isEncoding, outputText: viewModel.outputText)
            }
            .padding(.horizontal)
            .accessibilityElement(children: .combine)
            
            Spacer()
            
            // Hidden buttons for keyboard shortcuts
            HStack {
                Button(URLEncoderDecoderStrings.switchMode) {
                    viewModel.switchMode()
                }
                .keyboardShortcut("m", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                
                Button(URLEncoderDecoderStrings.switchAndProcess) {
                    viewModel.switchAndProcess()
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
            viewModel.lastActionAnnouncement = URLEncoderDecoderStrings.shortcutsHelpAccessibility
        }
        .accessibilityAction(named: URLEncoderDecoderStrings.Accessibility.showShortcuts) {
            viewModel.lastActionAnnouncement = URLEncoderDecoderStrings.Accessibility.shortcutsAvailable
        }
    }
    
}

#Preview {
    URLEncoderDecoderView()
}
