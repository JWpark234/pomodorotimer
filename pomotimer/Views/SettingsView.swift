//
//  SettingsView.swift
//  pomotimer
//
//  Created by Jinwoo Park on 2024/01/16.
//

import SwiftUI

struct SettingsView: View {
    @Binding var settingsPresented: Bool
    
    var body: some View {
        VStack{
            Button {
                settingsPresented = false
            } label: {
                Text("< Back")
                    .padding(.top, 50.0)
                    .padding(.trailing, 300)
            }
        }
        
    }
}

#Preview {
    SettingsView(settingsPresented: Binding(get: {
        return true
    }, set: { _ in
        
    }))
}
