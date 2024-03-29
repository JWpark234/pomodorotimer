//
//  TimeView.swift
//  pomotimer
//
//  Created by Jinwoo Park on 2024/01/19.
//

import SwiftUI

struct TimeView: View {
    @Binding var showView: Bool
    @State var which: Bool // true = work, false = rest
    
    
    var body: some View {
        //variables
        @AppStorage((which ? "workTime" : "restTime")) var time: Int = 5
        
        
        Text("Set your \((which ? "working" : "resting")) time")
            .font(.title2)
            .bold()
            .padding(.vertical, 50)
        
        //Form for setting time, move this to view
        Form {
            ZStack(alignment: Alignment.init(horizontal: .customCenter, vertical: .center)) {
                HStack {
                    Text(verbatim: "mins")
                        .foregroundColor(.clear)
                        .alignmentGuide(.customCenter) { $0[HorizontalAlignment.center] }
                    Text("mins")
                }
                
                Picker(
                    selection: $time,
                    label: Text("Select time in minutes"),
                    content: {
                        ForEach(1..<60) { number in
                            Text("\(number)").tag(number * 60)
                        }
                    }
                )
                .pickerStyle(WheelPickerStyle())
                .frame(height: 200)
                
            } //end of ZStack
            
            
            Button {
                showView = false
            } label: {
                ZStack{
                    Color.orange
                    Text("Submit")
                        .foregroundColor(.white)
                }
                .cornerRadius(5)
                
            }

        }
        ._safeAreaInsets(EdgeInsets(top: -40, leading: 0, bottom: 0, trailing: 0))
        .scrollContentBackground(.hidden)
    }
}

private extension HorizontalAlignment {
    enum CustomCenter: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat { context[HorizontalAlignment.center] }
    }
    
    static let customCenter = Self(CustomCenter.self)
}



#Preview {
    TimeView(showView: .constant(true), which: true)
}
