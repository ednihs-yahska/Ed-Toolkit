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
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 10) {
                Text("Diff Matcher")
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("Compare two texts and see the differences")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            // Main content
            if !showResults {
                // Input view
                VStack(spacing: 20) {
                    // Text input areas
                    HSplitView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Original Text")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            TextEditor(text: $leftText)
                                .font(.system(.body, design: .monospaced))
                                .padding(4)
                                .background(Color(NSColor.textBackgroundColor))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Modified Text")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            TextEditor(text: $rightText)
                                .font(.system(.body, design: .monospaced))
                                .padding(4)
                                .background(Color(NSColor.textBackgroundColor))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Compare button
                    Button(action: performDiff) {
                        Label("Compare", systemImage: "arrow.triangle.2.circlepath")
                            .frame(width: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(leftText.isEmpty && rightText.isEmpty)
                    .padding(.bottom)
                }
            } else {
                // Results view
                VStack(spacing: 16) {
                    HStack {
                        Button(action: { showResults = false }) {
                            Label("Back to Input", systemImage: "arrow.left")
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 16) {
                                Label("\(diffResults.filter { $0.type == .addition }.count) additions", systemImage: "plus.circle.fill")
                                    .foregroundColor(.green)
                                
                                Label("\(diffResults.filter { $0.type == .deletion }.count) deletions", systemImage: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                    
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
                }
                .padding(.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func performDiff() {
        let leftLines = leftText.components(separatedBy: .newlines)
        let rightLines = rightText.components(separatedBy: .newlines)
        
        diffResults = computeDiff(leftLines: leftLines, rightLines: rightLines)
        showResults = true
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
    }
}

#Preview {
    DiffMatcherView()
}