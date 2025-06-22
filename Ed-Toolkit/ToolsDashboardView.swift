//
//  ToolsDashboardView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/21/25.
//

import SwiftUI

enum Tool: String, CaseIterable {
    case urlEncoderDecoder = "URL Encoder/Decoder"
    case jsonFormatter = "JSON Formatter"
    
    var icon: String {
        switch self {
        case .urlEncoderDecoder:
            return "link"
        case .jsonFormatter:
            return "curlybraces"
        }
    }
}

struct ToolsDashboardView: View {
    @State private var selectedTool: Tool? = .urlEncoderDecoder
    
    var body: some View {
        NavigationSplitView {
            List(Tool.allCases, id: \.self, selection: $selectedTool) { tool in
                NavigationLink(value: tool) {
                    Label(tool.rawValue, systemImage: tool.icon)
                }
            }
            .navigationTitle("Tools")
        } detail: {
            if let selectedTool {
                switch selectedTool {
                case .urlEncoderDecoder:
                    URLEncoderDecoderView()
                case .jsonFormatter:
                    JSONFormatterView()
                }
            } else {
                Text("Select a tool")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ToolsDashboardView()
}