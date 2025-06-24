//
//  Tool.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/24/25.
//

import Foundation

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