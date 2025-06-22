//
//  ToolsDashboardView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/21/25.
//

import SwiftUI

enum Tool: String, CaseIterable {
    case urlEncoderDecoder = "url_encoder_decoder"
    case jsonFormatter = "json_formatter"
    case diffMatcher = "diff_matcher"
    
    var icon: String {
        switch self {
        case .urlEncoderDecoder:
            return "link"
        case .jsonFormatter:
            return "curlybraces"
        case .diffMatcher:
            return "arrow.triangle.branch"
        }
    }
    
    var displayName: String {
        switch self {
        case .urlEncoderDecoder:
            return ToolsDashboardStrings.urlEncoderDecoder
        case .jsonFormatter:
            return ToolsDashboardStrings.jsonFormatter
        case .diffMatcher:
            return ToolsDashboardStrings.diffMatcher
        }
    }
}

struct ToolsDashboardView: View {
    @State private var selectedTool: Tool? = .urlEncoderDecoder
    
    var body: some View {
        NavigationSplitView {
            List(Tool.allCases, id: \.self, selection: $selectedTool) { tool in
                NavigationLink(value: tool) {
                    Label(tool.displayName, systemImage: tool.icon)
                }
                .accessibilityLabel("\(ToolsDashboardStrings.Accessibility.toolItem): \(tool.displayName)")
                .accessibilityHint(ToolsDashboardStrings.Accessibility.selectToolHint)
                .accessibilityIdentifier("ToolsDashboard.tool.\(tool.rawValue)")
            }
            .navigationTitle(ToolsDashboardStrings.navigationTitle)
            .accessibilityLabel(ToolsDashboardStrings.Accessibility.toolsList)
            .accessibilityIdentifier("ToolsDashboard.toolsList")
        } detail: {
            if let selectedTool {
                switch selectedTool {
                case .urlEncoderDecoder:
                    URLEncoderDecoderView()
                case .jsonFormatter:
                    JSONFormatterView()
                case .diffMatcher:
                    DiffMatcherView()
                }
            } else {
                Text(ToolsDashboardStrings.selectTool)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(ToolsDashboardStrings.selectTool)
                    .accessibilityIdentifier("ToolsDashboard.selectToolMessage")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(ToolsDashboardStrings.Accessibility.mainView)
        .accessibilityIdentifier("ToolsDashboard.mainView")
    }
}

#Preview {
    ToolsDashboardView()
}