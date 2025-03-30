//
//  SearchBar.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 30/03/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchTerm: String
    @FocusState var isTextFieldFocused: Bool
    var onCancel: () -> Void
    var body: some View {
        HStack (spacing: 0){
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(searchTerm.isEmpty ? .gray : .blue)
                
                TextField("What should I eat today?", text: $searchTerm)
                    .focused($isTextFieldFocused)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
            }
            .padding(10)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.trailing, 10)
            
            if isTextFieldFocused{
                Button(action: {
                    searchTerm = ""
                    isTextFieldFocused = false
                    onCancel()
                }) {
                    Text("Cancel")
                }
            }
        }.padding(.top, 10)
    }
}
