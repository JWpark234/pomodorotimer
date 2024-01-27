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
    
    @State var showTimeSettings: Bool = false
    @State var which: Bool = true //true is work, false is rest
    
    @AppStorage("blockSites") var blockSites: Bool = true
    @AppStorage("shouldStop") var shouldStop: Bool = true
    @AppStorage("currentCycle") var currentCycle: Int = 0
    @AppStorage("cycles") private var cycles: Int = 3
    
    
    var body: some View {
        NavigationView{
            VStack{
                Button {
                    if (currentCycle >= UserDefaults.standard.integer(forKey: "cycles")){
                        currentCycle = 0
                    }
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
                            timeButton(label: UserDefaults.standard.integer(forKey: "workTime")) {
                                which = true
                            }
                            
                        }
                        
                        HStack{ // resting duration
                            Text("Resting duration")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            Spacer()
                            
                            timeButton(label: UserDefaults.standard.integer(forKey: "restTime")) {
                                which = false
                            }
                        } // end of HStack
                        
                    } header: {Text("Time")} // end of section
                    
                    Section{
                        HStack{ // cycles
                            Text("Number of cycles")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            
                            Spacer()
                            
                            
                            Picker(selection: $cycles) {
                                ForEach(1...5, id: \.self) { value in
                                    ZStack{
                                        Color(red: 0.7, green: 0.7, blue: 0.7)
                                        Text("\(value)")
                                            .foregroundColor(.white)
                                    }
                                    .tag(value)
                                    .frame(width: 40)
                                    .cornerRadius(5)
                                    .tag(value)
                                }
                            } label: {
                                EmptyView()
                            }
                            .pickerStyle(MenuPickerStyle()) // picker for cycles
                    
                        } // end of HStack
                        
                        //toggle button for blocking sites
                        Toggle("Block other apps while focusing", isOn: $blockSites)
                            
                        //toggle button for stopping after each session
                        Toggle("Stop after each work/rest session", isOn: $shouldStop)
                        
                        //toggle button for disabling notifs after each session
                        
                    } header: {Text("Other")} // end of section
                    
                } // end of list
                .scrollContentBackground(.hidden)
                .font(.system(size: 14))
                
            } // end of VStack
        }
        .sheet(isPresented: $showTimeSettings) {
            TimeView(showView: $showTimeSettings, which: which)
        }// end of navigationView

        
    } // end of body
    
    
    private func timeButton(label: Int, action: @escaping () -> Void) -> some View {
        Button {
            showTimeSettings = true
            action()
        } label: {
            ZStack{
                Color(red: 0.7, green: 0.7, blue: 0.7)
                Text("\(label / 60) mins")
                    .foregroundColor(.white)
            }
            .frame(width: 80)
            .cornerRadius(5)
        }
    }
    
    
    
} // end of struct settingsview




#Preview {
    SettingsView(
        settingsPresented: .constant(true),
        which: true
    )
}
