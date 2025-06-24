//
//  DiffMatcherView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/22/25.
//

import SwiftUI

struct DiffMatcherView: View {
    @StateObject private var viewModel = DiffMatcherViewModel()
    @FocusState private var focusedField: FocusedField?
    
    enum FocusedField: Hashable {
        case leftText
        case rightText
        case compareButton
        case backButton
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 10) {
                Text(DiffMatcherStrings.title)
                    .font(.largeTitle)
                    .padding(.top)
                    .pageHeaderAccessibility(
                        label: DiffMatcherStrings.Accessibility.title,
                        hint: keyboardShortcutsHint,
                        identifier: "DiffMatcher.title"
                    )
                
                Text(DiffMatcherStrings.subtitle + " • ⌘R to compare • ⌘⌥→/← to navigate")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .decorativeTextAccessibility()
            }
            .padding(.bottom)
            
            // Main content
            if !viewModel.showingResult {
                // Input view
                VStack(spacing: 20) {
                    // Text input areas
                    HSplitView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(DiffMatcherStrings.originalText)
                                .font(.headline)
                                .padding(.horizontal)
                                .accessibilityLabel(DiffMatcherStrings.originalText)
                                .accessibilityIdentifier("DiffMatcher.originalTextLabel")
                            
                            TextEditor(text: $viewModel.originalText)
                                .font(.system(.body, design: .monospaced))
                                .padding(4)
                                .background(Color(NSColor.textBackgroundColor))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                                .focused($focusedField, equals: .leftText)
                                .textInputAccessibility(
                                    label: DiffMatcherStrings.Accessibility.originalTextEditor,
                                    hint: DiffMatcherStrings.Accessibility.originalTextHint,
                                    identifier: "DiffMatcher.originalTextEditor"
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(DiffMatcherStrings.modifiedText)
                                .font(.headline)
                                .padding(.horizontal)
                                .accessibilityLabel(DiffMatcherStrings.modifiedText)
                                .accessibilityIdentifier("DiffMatcher.modifiedTextLabel")
                            
                            TextEditor(text: $viewModel.modifiedText)
                                .font(.system(.body, design: .monospaced))
                                .padding(4)
                                .background(Color(NSColor.textBackgroundColor))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                                .focused($focusedField, equals: .rightText)
                                .textInputAccessibility(
                                    label: DiffMatcherStrings.Accessibility.modifiedTextEditor,
                                    hint: DiffMatcherStrings.Accessibility.modifiedTextHint,
                                    identifier: "DiffMatcher.modifiedTextEditor"
                                )
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Compare button
                    Button(action: { viewModel.compareDiffs(); focusedField = .backButton }) {
                        Label(DiffMatcherStrings.compare, systemImage: "arrow.triangle.2.circlepath")
                            .frame(width: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.originalText.isEmpty && viewModel.modifiedText.isEmpty)
                    .padding(.bottom)
                    .focused($focusedField, equals: .compareButton)
                    .actionButtonAccessibility(
                        label: DiffMatcherStrings.Accessibility.compareButton,
                        hint: DiffMatcherStrings.Accessibility.compareHint,
                        identifier: "DiffMatcher.compareButton"
                    )
                    .keyboardShortcut("r", modifiers: .command)
                }
            } else {
                // Results view
                VStack(spacing: 16) {
                    HStack {
                        Button(action: { viewModel.backToInput(); focusedField = .leftText }) {
                            Label(DiffMatcherStrings.backToInput, systemImage: "arrow.left")
                        }
                        .focused($focusedField, equals: .backButton)
                        .actionButtonAccessibility(
                            label: DiffMatcherStrings.Accessibility.backButton,
                            hint: DiffMatcherStrings.Accessibility.backHint,
                            identifier: "DiffMatcher.backButton"
                        )
                        .keyboardShortcut("b", modifiers: .command)
                
                // Add backspace shortcut for back button (hidden)
                Button("Back with Backspace") {
                    viewModel.backToInput()
                    focusedField = .leftText
                }
                .keyboardShortcut(.delete, modifiers: [])
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 16) {
                                Label(DiffMatcherStrings.additionsCount(viewModel.additionCount), systemImage: "plus.circle.fill")
                                    .foregroundColor(.green)
                                    .accessibilityLabel(DiffMatcherStrings.additionsCount(viewModel.additionCount))
                                
                                Label(DiffMatcherStrings.deletionsCount(viewModel.deletionCount), systemImage: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .accessibilityLabel(DiffMatcherStrings.deletionsCount(viewModel.deletionCount))
                            }
                            .font(.caption)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(DiffMatcherStrings.diffSummary(
                                additions: viewModel.additionCount,
                                deletions: viewModel.deletionCount
                            ))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Results view subtitle with navigation hint
                    Text("⌘B or Backspace to return")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .decorativeTextAccessibility()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(viewModel.diffResult.enumerated()), id: \.offset) { index, line in
                                DiffLineView(line: line, lineNumber: index + 1)
                            }
                        }
                        .padding()
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel(DiffMatcherStrings.Accessibility.resultsView)
                    .accessibilityHint(DiffMatcherStrings.Accessibility.resultsHint)
                    .accessibilityIdentifier("DiffMatcher.resultsScrollView")
                }
                .padding(.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .mainViewAccessibility(
            label: DiffMatcherStrings.Accessibility.mainView,
            identifier: "DiffMatcher.mainView"
        )
        .onAppear {
            // Set initial focus to left text area
            focusedField = .leftText
        }
        .accessibilityAction(.default) {
            viewModel.lastActionAnnouncement = keyboardShortcutsHint
        }
        .accessibilityAction(named: "Show keyboard shortcuts") {
            viewModel.lastActionAnnouncement = keyboardShortcutsHint
        }
        // Hidden keyboard shortcuts
        .overlay(
            HStack {
                // Clear both text areas
                Button("Clear All") {
                    viewModel.clearAll()
                    focusedField = .leftText
                }
                .keyboardShortcut("k", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                
                // Swap text areas
                Button("Swap Texts") {
                    viewModel.swapTexts()
                }
                .keyboardShortcut("s", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                
                // Navigation shortcuts
                Button("Move to Right Text") {
                    focusedField = .rightText
                }
                .keyboardShortcut(.rightArrow, modifiers: [.command, .option])
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                
                Button("Move to Left Text") {
                    focusedField = .leftText
                }
                .keyboardShortcut(.leftArrow, modifiers: [.command, .option])
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
            }
        )
    }
    
    private var keyboardShortcutsHint: String {
        DiffMatcherStrings.Accessibility.keyboardShortcuts
    }
    
}


struct DiffLineView: View {
    let line: DiffMatcherViewModel.DiffLine
    let lineNumber: Int
    
    var backgroundColor: Color {
        switch line.type {
        case .unchanged:
            return Color.clear
        case .added:
            return Color.green.opacity(0.2)
        case .removed:
            return Color.red.opacity(0.2)
        }
    }
    
    var prefixSymbol: String {
        switch line.type {
        case .unchanged:
            return " "
        case .added:
            return "+"
        case .removed:
            return "-"
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Line numbers
            HStack(spacing: 8) {
                Text(line.originalLineNumber.map { String($0) } ?? "")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .frame(width: 40, alignment: .trailing)
                
                Text(line.modifiedLineNumber.map { String($0) } ?? "")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .frame(width: 40, alignment: .trailing)
            }
            .padding(.horizontal, 8)
            
            // Prefix symbol
            Text(prefixSymbol)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(line.type == .added ? .green : line.type == .removed ? .red : .primary)
                .padding(.leading, 4)
            
            // Content
            Text(line.content.isEmpty ? " " : line.content)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
        }
        .background(backgroundColor)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLineDescription)
        .accessibilityIdentifier("DiffMatcher.diffLine.\(lineNumber)")
    }
    
    private var accessibilityLineDescription: String {
        switch line.type {
        case .unchanged:
            return "Line \(lineNumber): \(line.content.isEmpty ? "Empty line" : line.content)"
        case .added:
            return "Line \(lineNumber): Added: \(line.content.isEmpty ? "Empty line" : line.content)"
        case .removed:
            return "Line \(lineNumber): Deleted: \(line.content.isEmpty ? "Empty line" : line.content)"
        }
    }
}

#Preview {
    DiffMatcherView()
}