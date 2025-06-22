//
//  DiffMatcherView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/22/25.
//

import SwiftUI

struct DiffMatcherView: View {
    @State private var leftText = ""
    @State private var rightText = ""
    @State private var diffResults: [DiffLine] = []
    @State private var showResults = false
    @State private var lastActionAnnouncement = ""
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
            if !showResults {
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
                            
                            TextEditor(text: $leftText)
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
                            
                            TextEditor(text: $rightText)
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
                    Button(action: performDiff) {
                        Label(DiffMatcherStrings.compare, systemImage: "arrow.triangle.2.circlepath")
                            .frame(width: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(leftText.isEmpty && rightText.isEmpty)
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
                        Button(action: { goBackToInput() }) {
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
                    goBackToInput()
                }
                .keyboardShortcut(.delete, modifiers: [])
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 16) {
                                Label(DiffMatcherStrings.additionsCount(diffResults.filter { $0.type == .addition }.count), systemImage: "plus.circle.fill")
                                    .foregroundColor(.green)
                                    .accessibilityLabel(DiffMatcherStrings.additionsCount(diffResults.filter { $0.type == .addition }.count))
                                
                                Label(DiffMatcherStrings.deletionsCount(diffResults.filter { $0.type == .deletion }.count), systemImage: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .accessibilityLabel(DiffMatcherStrings.deletionsCount(diffResults.filter { $0.type == .deletion }.count))
                            }
                            .font(.caption)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(DiffMatcherStrings.diffSummary(
                                additions: diffResults.filter { $0.type == .addition }.count,
                                deletions: diffResults.filter { $0.type == .deletion }.count
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
                            ForEach(Array(diffResults.enumerated()), id: \.offset) { index, line in
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
            lastActionAnnouncement = keyboardShortcutsHint
        }
        .accessibilityAction(named: "Show keyboard shortcuts") {
            lastActionAnnouncement = keyboardShortcutsHint
        }
        // Hidden keyboard shortcuts
        .overlay(
            HStack {
                // Clear both text areas
                Button("Clear All") {
                    clearAllText()
                }
                .keyboardShortcut("k", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                
                // Swap text areas
                Button("Swap Texts") {
                    swapTexts()
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
    
    func performDiff() {
        guard !leftText.isEmpty || !rightText.isEmpty else {
            lastActionAnnouncement = DiffMatcherStrings.Accessibility.emptyInput
            return
        }
        
        let leftLines = leftText.components(separatedBy: .newlines)
        let rightLines = rightText.components(separatedBy: .newlines)
        
        diffResults = computeDiff(leftLines: leftLines, rightLines: rightLines)
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showResults = true
        }
        
        // Announce results to VoiceOver
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let additionCount = diffResults.filter { $0.type == .addition }.count
            let deletionCount = diffResults.filter { $0.type == .deletion }.count
            
            if additionCount == 0 && deletionCount == 0 {
                lastActionAnnouncement = DiffMatcherStrings.Accessibility.noChanges
            } else {
                lastActionAnnouncement = DiffMatcherStrings.diffSummary(additions: additionCount, deletions: deletionCount)
            }
        }
    }
    
    func goBackToInput() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showResults = false
        }
        
        // Set focus back to left text area
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            focusedField = .leftText
            lastActionAnnouncement = DiffMatcherStrings.Accessibility.returnedToInput
        }
    }
    
    func clearAllText() {
        leftText = ""
        rightText = ""
        diffResults = []
        showResults = false
        focusedField = .leftText
        lastActionAnnouncement = DiffMatcherStrings.Accessibility.allTextCleared
    }
    
    func swapTexts() {
        let temp = leftText
        leftText = rightText
        rightText = temp
        lastActionAnnouncement = DiffMatcherStrings.Accessibility.textsSwapped
    }
    
    func computeDiff(leftLines: [String], rightLines: [String]) -> [DiffLine] {
        var results: [DiffLine] = []
        
        // Simple line-by-line diff algorithm
        // This is a basic implementation - could be enhanced with LCS algorithm
        var leftIndex = 0
        var rightIndex = 0
        
        while leftIndex < leftLines.count || rightIndex < rightLines.count {
            if leftIndex >= leftLines.count {
                // Remaining lines in right are additions
                results.append(DiffLine(
                    content: rightLines[rightIndex],
                    type: .addition,
                    leftLineNumber: nil,
                    rightLineNumber: rightIndex + 1
                ))
                rightIndex += 1
            } else if rightIndex >= rightLines.count {
                // Remaining lines in left are deletions
                results.append(DiffLine(
                    content: leftLines[leftIndex],
                    type: .deletion,
                    leftLineNumber: leftIndex + 1,
                    rightLineNumber: nil
                ))
                leftIndex += 1
            } else if leftLines[leftIndex] == rightLines[rightIndex] {
                // Lines match
                results.append(DiffLine(
                    content: leftLines[leftIndex],
                    type: .unchanged,
                    leftLineNumber: leftIndex + 1,
                    rightLineNumber: rightIndex + 1
                ))
                leftIndex += 1
                rightIndex += 1
            } else {
                // Lines differ - check if it's a modification or separate add/delete
                // For simplicity, treat as delete followed by add
                results.append(DiffLine(
                    content: leftLines[leftIndex],
                    type: .deletion,
                    leftLineNumber: leftIndex + 1,
                    rightLineNumber: nil
                ))
                results.append(DiffLine(
                    content: rightLines[rightIndex],
                    type: .addition,
                    leftLineNumber: nil,
                    rightLineNumber: rightIndex + 1
                ))
                leftIndex += 1
                rightIndex += 1
            }
        }
        
        return results
    }
}

struct DiffLine {
    let content: String
    let type: DiffType
    let leftLineNumber: Int?
    let rightLineNumber: Int?
}

enum DiffType {
    case unchanged
    case addition
    case deletion
}

struct DiffLineView: View {
    let line: DiffLine
    let lineNumber: Int
    
    var backgroundColor: Color {
        switch line.type {
        case .unchanged:
            return Color.clear
        case .addition:
            return Color.green.opacity(0.2)
        case .deletion:
            return Color.red.opacity(0.2)
        }
    }
    
    var prefixSymbol: String {
        switch line.type {
        case .unchanged:
            return " "
        case .addition:
            return "+"
        case .deletion:
            return "-"
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Line numbers
            HStack(spacing: 8) {
                Text(line.leftLineNumber.map { String($0) } ?? "")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .frame(width: 40, alignment: .trailing)
                
                Text(line.rightLineNumber.map { String($0) } ?? "")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .frame(width: 40, alignment: .trailing)
            }
            .padding(.horizontal, 8)
            
            // Prefix symbol
            Text(prefixSymbol)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(line.type == .addition ? .green : line.type == .deletion ? .red : .primary)
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
        case .addition:
            return "Line \(lineNumber): Added: \(line.content.isEmpty ? "Empty line" : line.content)"
        case .deletion:
            return "Line \(lineNumber): Deleted: \(line.content.isEmpty ? "Empty line" : line.content)"
        }
    }
}

#Preview {
    DiffMatcherView()
}