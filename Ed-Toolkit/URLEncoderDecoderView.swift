//
//  URLEncoderDecoderView.swift
//  Ed-Toolkit
//
//  Created by Akshay Shinde on 6/21/25.
//

import SwiftUI

struct URLEncoderDecoderView: View {
    @State private var inputText = ""
    @State private var outputText = ""
    @State private var isEncoding = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("URL Encoder/Decoder")
                .font(.largeTitle)
                .padding()
            
            Picker("Mode", selection: $isEncoding) {
                Text("Encode").tag(true)
                Text("Decode").tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Input:")
                    .font(.headline)
                TextEditor(text: $inputText)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            Button(action: processURL) {
                Label(isEncoding ? "Encode" : "Decode", systemImage: "arrow.down.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            
            VStack(alignment: .leading) {
                Text("Output:")
                    .font(.headline)
                TextEditor(text: .constant(outputText))
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    func processURL() {
        if isEncoding {
            outputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        } else {
            outputText = inputText.removingPercentEncoding ?? ""
        }
    }
}

#Preview {
    URLEncoderDecoderView()
}