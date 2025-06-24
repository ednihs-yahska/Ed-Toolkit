//
//  URLEncoderDecoderViewModel.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/24/25.
//

import Foundation
import SwiftUI

@MainActor
class URLEncoderDecoderViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var outputText = ""
    @Published var isEncoding = true
    @Published var lastActionAnnouncement = ""
    
    func processText() {
        if isEncoding {
            encodeText()
        } else {
            decodeText()
        }
    }
    
    func switchMode() {
        isEncoding.toggle()
        outputText = ""
        lastActionAnnouncement = isEncoding ? URLEncoderDecoderStrings.Status.switchedToEncode : URLEncoderDecoderStrings.Status.switchedToDecode
    }
    
    func switchAndProcess() {
        isEncoding.toggle()
        processText()
    }
    
    private func encodeText() {
        guard !inputText.isEmpty else {
            lastActionAnnouncement = URLEncoderDecoderStrings.Status.noInput
            return
        }
        
        if let encoded = inputText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            outputText = encoded
            let characterCount = encoded.count
            lastActionAnnouncement = URLEncoderDecoderStrings.Status.encodedSuccess(characterCount: characterCount)
        } else {
            outputText = ""
            lastActionAnnouncement = URLEncoderDecoderStrings.Status.encodingFailed
        }
    }
    
    private func decodeText() {
        guard !inputText.isEmpty else {
            lastActionAnnouncement = URLEncoderDecoderStrings.Status.noInput
            return
        }
        
        if let decoded = inputText.removingPercentEncoding {
            outputText = decoded
            let characterCount = decoded.count
            lastActionAnnouncement = URLEncoderDecoderStrings.Status.decodedSuccess(characterCount: characterCount)
        } else {
            outputText = ""
            lastActionAnnouncement = URLEncoderDecoderStrings.Status.decodingFailed
        }
    }
}