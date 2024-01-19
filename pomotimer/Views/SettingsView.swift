//
//  SettingsView.swift
//  pomotimer
//
//  Created by Jinwoo Park on 2024/01/16.
//

import SwiftUI

struct SettingsView: View {
    //for light/dark mode detection
    @Environment(\.colorScheme) var colorScheme
    
    //to show the settings or not
    @Binding var settingsPresented: Bool
    
    //bindings for updating time
    @Binding var workTime: Int
    @Binding var restTime: Int
    @Binding var cycles: Int
    
    @State var showTimeSettings: Bool = false
    @State var which: Bool = true //true is work, false is rest
    
    @Binding var blockSites: Bool
    
    
    var body: some View {
        NavigationView{
            VStack{
                Button {
                    settingsPresented = false
                } label: {
                    Text("< Back")
                        .padding(.top, 50.0)
                        .padding(.trailing, 300)
                }
                
                Text("Settings")
                    .font(.largeTitle)
                
                //list for settings
                List{
                    //For time
                    Section{
                        HStack{ // working duration
                            Text("Working duration")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            Spacer()
                            Button { // for working
                                which = true
                                showTimeSettings = true
                                
                            } label: {
                                ZStack{
                                    Color(red: 0.7, green: 0.7, blue: 0.7)
                                    Text("\(workTime / 60) mins")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 80)
                                .cornerRadius(5)
                            }
                        }
                        
                        HStack{ // resting duration
                            Text("Resting duration")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            Spacer()
                            Button {
                                which = false
                                showTimeSettings = true
                                
                            } label: {
                                ZStack{
                                    Color(red: 0.7, green: 0.7, blue: 0.7)
                                    Text("\(restTime / 60) mins")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 80)
                                .cornerRadius(5)
                            }
                        } // end of HStack
                        
                    } header: {Text("Time")} // end of section
                    
                    Section{
                        HStack{ // cycles
                            Text("Number of cycles")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            
                            Spacer()
                            
                            Picker(selection: $cycles) { // picker for cycles
                                ForEach(1..<6) { number in
                                    ZStack{
                                        Color(red: 0.7, green: 0.7, blue: 0.7)
                                        Text("\(number)")
                                            .tag(number)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 40)
                                    .cornerRadius(5)
                                }
                            } label: {
                                EmptyView()
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                        } // end of HStack
                        
                        //toggle button for blocking sites
                        Toggle("Block other apps while focusing", isOn: $blockSites)
                            
                        //toggle button for disabling notifications after each session
                        
                        
                    } header: {Text("Other")} // end of section
                    
                } // end of list
                .scrollContentBackground(.hidden)
                .font(.system(size: 14))
                
                
                
                
            } // end of VStack
        } // end of navigationView
        .sheet(isPresented: $showTimeSettings) {
            TimeView(text: (which ? "work" : "rest"), showView: $showTimeSettings, time: (which ? $workTime : $restTime))
        }

        
    }
}



#Preview {
    SettingsView(settingsPresented: Binding(get: {
        return true
    }, set: { _ in
        
    }), workTime: Binding(get: {
        return 120
    }, set: { _ in
        
    }), restTime: Binding(get: {
        return 120
    }, set: { _ in
        
    }), cycles: Binding(get: {
        return 3
    }, set: { _ in
        
    }), which: true, blockSites: Binding(get: {
        return false
    }, set: { _ in
        
    }))
}
