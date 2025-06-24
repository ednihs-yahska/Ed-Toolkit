//
//  DiffMatcherViewModel.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/24/25.
//

import Foundation
import SwiftUI

@MainActor
class DiffMatcherViewModel: ObservableObject {
    @Published var originalText = ""
    @Published var modifiedText = ""
    @Published var diffResult: [DiffLine] = []
    @Published var showingResult = false
    @Published var lastActionAnnouncement = ""
    
    struct DiffLine: Identifiable {
        let id = UUID()
        let originalLineNumber: Int?
        let modifiedLineNumber: Int?
        let content: String
        let type: DiffType
    }
    
    enum DiffType {
        case unchanged
        case added
        case removed
    }
    
    var additionCount: Int {
        diffResult.filter { $0.type == .added }.count
    }
    
    var deletionCount: Int {
        diffResult.filter { $0.type == .removed }.count
    }
    
    func compareDiffs() {
        if originalText.isEmpty || modifiedText.isEmpty {
            lastActionAnnouncement = DiffMatcherStrings.Accessibility.emptyInput
            return
        }
        
        let originalLines = originalText.components(separatedBy: .newlines)
        let modifiedLines = modifiedText.components(separatedBy: .newlines)
        
        diffResult = computeDiff(original: originalLines, modified: modifiedLines)
        showingResult = true
        
        let announcement = DiffMatcherStrings.diffSummary(additions: additionCount, deletions: deletionCount)
        lastActionAnnouncement = announcement
    }
    
    func swapTexts() {
        let temp = originalText
        originalText = modifiedText
        modifiedText = temp
        lastActionAnnouncement = DiffMatcherStrings.Accessibility.textsSwapped
    }
    
    func clearAll() {
        originalText = ""
        modifiedText = ""
        diffResult = []
        showingResult = false
        lastActionAnnouncement = DiffMatcherStrings.Accessibility.allTextCleared
    }
    
    func backToInput() {
        showingResult = false
        lastActionAnnouncement = DiffMatcherStrings.Accessibility.returnedToInput
    }
    
    private func computeDiff(original: [String], modified: [String]) -> [DiffLine] {
        var result: [DiffLine] = []
        var originalIndex = 0
        var modifiedIndex = 0
        
        while originalIndex < original.count || modifiedIndex < modified.count {
            if originalIndex >= original.count {
                // Rest are additions
                while modifiedIndex < modified.count {
                    result.append(DiffLine(
                        originalLineNumber: nil,
                        modifiedLineNumber: modifiedIndex + 1,
                        content: modified[modifiedIndex],
                        type: .added
                    ))
                    modifiedIndex += 1
                }
            } else if modifiedIndex >= modified.count {
                // Rest are deletions
                while originalIndex < original.count {
                    result.append(DiffLine(
                        originalLineNumber: originalIndex + 1,
                        modifiedLineNumber: nil,
                        content: original[originalIndex],
                        type: .removed
                    ))
                    originalIndex += 1
                }
            } else if original[originalIndex] == modified[modifiedIndex] {
                // Unchanged line
                result.append(DiffLine(
                    originalLineNumber: originalIndex + 1,
                    modifiedLineNumber: modifiedIndex + 1,
                    content: original[originalIndex],
                    type: .unchanged
                ))
                originalIndex += 1
                modifiedIndex += 1
            } else {
                // For simplicity, treating as deletion followed by addition
                result.append(DiffLine(
                    originalLineNumber: originalIndex + 1,
                    modifiedLineNumber: nil,
                    content: original[originalIndex],
                    type: .removed
                ))
                result.append(DiffLine(
                    originalLineNumber: nil,
                    modifiedLineNumber: modifiedIndex + 1,
                    content: modified[modifiedIndex],
                    type: .added
                ))
                originalIndex += 1
                modifiedIndex += 1
            }
        }
        
        return result
    }
}