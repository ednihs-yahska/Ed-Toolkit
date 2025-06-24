//
//  JSONFormatterViewModel.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/24/25.
//

import Foundation
import SwiftUI

@MainActor
class JSONFormatterViewModel: ObservableObject {
    @Published var inputJSON = ""
    @Published var parsedJSON: Any?
    @Published var errorMessage = ""
    @Published var lastActionAnnouncement = ""
    @Published var expandedItems: Set<String> = []
    
    func parseJSON(_ jsonString: String) {
        errorMessage = ""
        parsedJSON = nil
        
        guard !jsonString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        guard let data = jsonString.data(using: .utf8) else {
            errorMessage = JSONFormatterStrings.invalidInput
            lastActionAnnouncement = JSONFormatterStrings.Accessibility.parseError
            return
        }
        
        do {
            parsedJSON = try JSONSerialization.jsonObject(with: data, options: [])
            lastActionAnnouncement = JSONFormatterStrings.Accessibility.jsonParsed
        } catch {
            errorMessage = "\(JSONFormatterStrings.invalidJSONPrefix) \(error.localizedDescription)"
            lastActionAnnouncement = JSONFormatterStrings.Accessibility.parseError
        }
    }
    
    func clearInput() {
        inputJSON = ""
        parsedJSON = nil
        errorMessage = ""
        lastActionAnnouncement = "Input cleared"
    }
    
    func formatJSON() {
        guard !inputJSON.isEmpty else {
            lastActionAnnouncement = JSONFormatterStrings.Accessibility.emptyInput
            return
        }
        
        guard let data = inputJSON.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let formattedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let formattedString = String(data: formattedData, encoding: .utf8) else {
            lastActionAnnouncement = JSONFormatterStrings.Accessibility.parseError
            return
        }
        
        inputJSON = formattedString
        lastActionAnnouncement = "JSON formatted"
    }
    
    func toggleExpanded(at path: String) {
        if expandedItems.contains(path) {
            expandedItems.remove(path)
        } else {
            expandedItems.insert(path)
        }
    }
    
    func isExpanded(at path: String) -> Bool {
        expandedItems.contains(path)
    }
}