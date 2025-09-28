//
//  CustomSearchBarView.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import SwiftUI

struct CustomSearchBarView: View {
    @Binding var text: String
    let onVoiceSearch: () -> Void
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.white)
                .opacity(0.5)
                .padding(.leading, 8)
            
            TextField("Search", text: $text)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.white)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.top, 8)
                .padding(.bottom, 8)
                .onTapGesture {
                    isEditing = true
                }
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.white)
                        .opacity(0.5)
                }
            }
            
            Button(action: onVoiceSearch) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.white)
                    .opacity(0.5)
            }
            .padding(.trailing, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.textField)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(isEditing ? Color.stroke : Color.clear)
        )
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }
}

#Preview {
    CustomSearchBarView(
        text: .constant(""),
        onVoiceSearch: {}
    )
}
