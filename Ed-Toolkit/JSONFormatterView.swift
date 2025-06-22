//
//  JSONFormatterView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/21/25.
//

import SwiftUI

struct JSONFormatterView: View {
    @State private var inputJSON = ""
    @State private var parsedJSON: Any?
    @State private var errorMessage = ""
    
    var body: some View {
        HSplitView {
            // Left side - Input
            VStack(alignment: .leading, spacing: 10) {
                Text("Input JSON")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                
                TextEditor(text: $inputJSON)
                    .font(.system(.body, design: .monospaced))
                    .padding(4)
                    .background(Color(NSColor.textBackgroundColor))
                    .onChange(of: inputJSON) { _, newValue in
                        parseJSON(newValue)
                    }
            }
            .frame(minWidth: 300)
            
            // Right side - Outline View
            VStack(alignment: .leading, spacing: 10) {
                Text("JSON Structure")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                
                if let parsedJSON = parsedJSON {
                    ScrollView {
                        JSONOutlineView(json: parsedJSON)
                            .padding()
                    }
                    .background(Color(NSColor.textBackgroundColor))
                } else if !errorMessage.isEmpty {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(NSColor.textBackgroundColor))
                } else {
                    VStack {
                        Image(systemName: "doc.text")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Paste JSON to see structure")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(NSColor.textBackgroundColor))
                }
            }
            .frame(minWidth: 300)
        }
    }
    
    func parseJSON(_ jsonString: String) {
        errorMessage = ""
        parsedJSON = nil
        
        guard !jsonString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        guard let data = jsonString.data(using: .utf8) else {
            errorMessage = "Invalid input"
            return
        }
        
        do {
            parsedJSON = try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            errorMessage = "Invalid JSON: \(error.localizedDescription)"
        }
    }
}

struct JSONOutlineView: View {
    let json: Any
    @State private var expandedItems: Set<String> = []
    
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
                } else if let array = value as? [Any] {
                    Text("[\(array.count)]")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                } else if let string = value as? String {
                    Text("\"\(string)\"")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                        .lineLimit(1)
                } else if let number = value as? NSNumber {
                    Text(number.stringValue)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.orange)
                } else if value is NSNull {
                    Text("null")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)
                } else if let bool = value as? Bool {
                    Text(bool ? "true" : "false")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.purple)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if value is [String: Any] || value is [Any] {
                    toggleExpanded()
                }
            }
            
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
}

#Preview {
    JSONFormatterView()
}
