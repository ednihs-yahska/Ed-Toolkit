//
//  JSONFormatterView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/21/25.
//

import SwiftUI

struct JSONFormatterView: View {
    @StateObject private var viewModel = JSONFormatterViewModel()
    @FocusState private var focusedField: FocusedField?
    
    enum FocusedField: Hashable {
        case inputEditor
        case structureView
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 10) {
                Text(JSONFormatterStrings.title)
                    .font(.largeTitle)
                    .padding(.top)
                    .pageHeaderAccessibility(
                        label: JSONFormatterStrings.Accessibility.title,
                        hint: keyboardShortcutsHint,
                        identifier: "JSONFormatter.title"
                    )
                
                Text(JSONFormatterStrings.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .decorativeTextAccessibility()
            }
            .padding(.bottom)
            
            HSplitView {
                // Left side - Input
                VStack(alignment: .leading, spacing: 10) {
                    Text(JSONFormatterStrings.inputLabel)
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)
                        .accessibilityLabel(JSONFormatterStrings.inputLabel)
                        .accessibilityIdentifier("JSONFormatter.inputLabel")
                
                    PlainTextEditor.code(
                        text: $viewModel.inputJSON
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .focused($focusedField, equals: .inputEditor)
                    .textInputAccessibility(
                        label: JSONFormatterStrings.Accessibility.inputEditor,
                        hint: JSONFormatterStrings.Accessibility.inputHint,
                        identifier: "JSONFormatter.inputEditor"
                    )
                    .onChange(of: viewModel.inputJSON) { _, newValue in
                        viewModel.parseJSON(newValue)
                    }
            }
            .frame(minWidth: 300)
            
                // Right side - Outline View
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(JSONFormatterStrings.structureLabel)
                            .font(.headline)
                            .accessibilityLabel(JSONFormatterStrings.structureLabel)
                            .accessibilityIdentifier("JSONFormatter.structureLabel")
                        
                        Spacer()
                        
                        if viewModel.parsedJSON != nil {
                            Button(action: {
                                viewModel.copyFormattedJSON()
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "doc.on.doc")
                                        .font(.system(size: 12))
                                    Text(JSONFormatterStrings.copy)
                                        .font(.caption)
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .actionButtonAccessibility(
                                label: JSONFormatterStrings.Accessibility.copyButton,
                                hint: JSONFormatterStrings.Accessibility.copyHint,
                                identifier: "JSONFormatter.copyButton"
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                
                    if let parsedJSON = viewModel.parsedJSON {
                        ScrollView {
                            JSONOutlineView(json: parsedJSON, expandedItems: $viewModel.expandedItems)
                                .padding()
                        }
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .structureView)
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel(JSONFormatterStrings.Accessibility.structureView)
                        .accessibilityHint(JSONFormatterStrings.Accessibility.structureHint)
                        .accessibilityIdentifier("JSONFormatter.structureView")
                    } else if !viewModel.errorMessage.isEmpty {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text(viewModel.errorMessage)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(JSONFormatterStrings.Accessibility.errorView)
                        .accessibilityValue(viewModel.errorMessage)
                        .accessibilityIdentifier("JSONFormatter.errorView")
                    } else {
                        VStack {
                            Image(systemName: "doc.text")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text(JSONFormatterStrings.placeholderText)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(JSONFormatterStrings.Accessibility.placeholderView)
                        .accessibilityHint(JSONFormatterStrings.placeholderText)
                        .accessibilityIdentifier("JSONFormatter.placeholderView")
                    }
                }
                .frame(minWidth: 300)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .mainViewAccessibility(
            label: JSONFormatterStrings.Accessibility.mainView,
            identifier: "JSONFormatter.mainView"
        )
        .onAppear {
            // Set initial focus to input editor
            focusedField = .inputEditor
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
                // Clear input
                Button("Clear Input") {
                    viewModel.clearInput()
                    focusedField = .inputEditor
                }
                .keyboardShortcut("k", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                
                // Format JSON
                Button("Format JSON") {
                    viewModel.formatJSON()
                }
                .keyboardShortcut("f", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
                
                // Copy JSON
                Button("Copy JSON") {
                    viewModel.copyFormattedJSON()
                }
                .keyboardShortcut("c", modifiers: [.command, .option])
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
            }
        )
    }
    
    private var keyboardShortcutsHint: String {
        JSONFormatterStrings.Accessibility.keyboardShortcuts
    }
    
}

struct JSONOutlineView: View {
    let json: Any
    @Binding var expandedItems: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            JSONNodeView(
                key: nil,
                value: json,
                path: "",
                expandedItems: $expandedItems
            )
        }
    }
}

struct JSONNodeView: View {
    let key: String?
    let value: Any
    let path: String
    @Binding var expandedItems: Set<String>
    
    var isExpanded: Bool {
        expandedItems.contains(path)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                // Disclosure triangle for objects and arrays
                if value is [String: Any] || value is [Any] {
                    Button(action: toggleExpanded) {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 10))
                            .frame(width: 12, height: 12)
                    }
                    .buttonStyle(.plain)
                    .actionButtonAccessibility(
                        label: isExpanded ? JSONFormatterStrings.Accessibility.collapseButton : JSONFormatterStrings.Accessibility.expandButton,
                        hint: isExpanded ? JSONFormatterStrings.Accessibility.collapseHint : JSONFormatterStrings.Accessibility.expandHint,
                        identifier: "JSONFormatter.toggleButton.\(path)"
                    )
                } else {
                    Spacer()
                        .frame(width: 16)
                }
                
                // Key
                if let key = key {
                    Text("\(key):")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)
                }
                
                // Value or type indicator
                if let dict = value as? [String: Any] {
                    Text("{\(dict.count)}")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                        .accessibilityLabel(JSONFormatterStrings.objectCount(dict.count))
                        .accessibilityAddTraits(.isStaticText)
                } else if let array = value as? [Any] {
                    Text("[\(array.count)]")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                        .accessibilityLabel(JSONFormatterStrings.arrayCount(array.count))
                        .accessibilityAddTraits(.isStaticText)
                } else if let string = value as? String {
                    Text("\"\(string)\"")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                        .lineLimit(1)
                        .accessibilityLabel("\(JSONFormatterStrings.stringType): \(string)")
                        .accessibilityAddTraits(.isStaticText)
                } else if let number = value as? NSNumber {
                    Text(number.stringValue)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.orange)
                        .accessibilityLabel("\(JSONFormatterStrings.numberType): \(number.stringValue)")
                        .accessibilityAddTraits(.isStaticText)
                } else if value is NSNull {
                    Text("null")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)
                        .accessibilityLabel(JSONFormatterStrings.nullType)
                        .accessibilityAddTraits(.isStaticText)
                } else if let bool = value as? Bool {
                    Text(bool ? "true" : "false")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.purple)
                        .accessibilityLabel("\(JSONFormatterStrings.booleanType): \(bool ? "true" : "false")")
                        .accessibilityAddTraits(.isStaticText)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if value is [String: Any] || value is [Any] {
                    toggleExpanded()
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(value is [String: Any] || value is [Any] ? .isButton : .isStaticText)
            .accessibilityLabel(accessibilityNodeDescription)
            .accessibilityHint(value is [String: Any] || value is [Any] ? JSONFormatterStrings.Accessibility.nodeHint : "")
            .accessibilityIdentifier("JSONFormatter.node.\(path)")
            .keyboardShortcut(.space, modifiers: [])
            
            // Children
            if isExpanded {
                VStack(alignment: .leading, spacing: 2) {
                    if let dict = value as? [String: Any] {
                        ForEach(dict.keys.sorted(), id: \.self) { key in
                            JSONNodeView(
                                key: key,
                                value: dict[key]!,
                                path: path.isEmpty ? key : "\(path).\(key)",
                                expandedItems: $expandedItems
                            )
                            .padding(.leading, 16)
                        }
                    } else if let array = value as? [Any] {
                        ForEach(0..<array.count, id: \.self) { index in
                            JSONNodeView(
                                key: "[\(index)]",
                                value: array[index],
                                path: "\(path)[\(index)]",
                                expandedItems: $expandedItems
                            )
                            .padding(.leading, 16)
                        }
                    }
                }
            }
        }
    }
    
    func toggleExpanded() {
        if isExpanded {
            expandedItems.remove(path)
        } else {
            expandedItems.insert(path)
        }
    }
    
    private var accessibilityNodeDescription: String {
        let nodeTypeDescription: String
        
        if let dict = value as? [String: Any] {
            nodeTypeDescription = JSONFormatterStrings.objectCount(dict.count)
        } else if let array = value as? [Any] {
            nodeTypeDescription = JSONFormatterStrings.arrayCount(array.count)
        } else if let string = value as? String {
            nodeTypeDescription = "\(JSONFormatterStrings.stringType): \(string)"
        } else if let number = value as? NSNumber {
            nodeTypeDescription = "\(JSONFormatterStrings.numberType): \(number.stringValue)"
        } else if value is NSNull {
            nodeTypeDescription = JSONFormatterStrings.nullType
        } else if let bool = value as? Bool {
            nodeTypeDescription = "\(JSONFormatterStrings.booleanType): \(bool ? "true" : "false")"
        } else {
            nodeTypeDescription = "Unknown type"
        }
        
        return JSONFormatterStrings.nodeDescription(key: key, type: nodeTypeDescription)
    }
}

#Preview {
    JSONFormatterView()
}
