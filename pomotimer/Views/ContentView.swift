//
//  ContentView.swift
//  pomotimer
//
//  Created by Jinwoo Park on 2024/01/10.
//

import SwiftUI
import SwiftData
import UserNotifications

private var timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

struct ContentView: View {
    //Counters for rest and work time
    @State var Counter: Int = 0
    @State var countTo: Int = 5  //in seconds
    
    @State var secondCounter: Int = 0;
    @State var restTo: Int = 5 //5 minutes
    
    //Counter for amount of cycles
    @State var currentCycle: Int = 0
    @State var cycleTo: Int = 3
    
    //buttons
    @State var buttonMessage = true
    @State var buttonColor = true
    @State var timerOn = false
    @State var working = true
    @State var showView = false
    
    
    //For blocking sites
    @State var blockSites = false
    
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Pomodoro cycle #\(currentCycle + 1)")
                    .font(.largeTitle)
                    .padding(.bottom, 5)
                Text("\(cycleTo - currentCycle) more left to go")
                    .font(.title)
                    .padding(.bottom, 20)
                ZStack{
                    //first circle for base
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)
                        .overlay(
                            Circle().stroke(Color.green, lineWidth: 25)
                            )
                        
                        //second circle for timer
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)
                        .overlay(
                            Circle().trim(from: 0, to: progress())  //how much of the  circle is actually written, from 0 to a number less than 1
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: 25,
                                        lineCap: .butt,
                                        lineJoin: .round
                                    )
                                )
                        )
                        .foregroundColor(
                            (completed() ? Color.orange: Color.red)
                        ).animation(
                            Animation.linear(duration: 1),
                            value: (working ? Counter : secondCounter)
                        )
                        
                        //Clock structure for displaying time
                    if (working){
                        Clock(counter: Counter, countTo: countTo)
                    }
                    else {
                        Clock(counter: secondCounter, countTo: restTo)
                    }
                        
                } // End of ZStack
                    
                Text(working ? "Currently working..." : "Currently resting!")
                    .padding(20)
                    
                //buttons for start/stop and restart
                HStack{
                    Spacer()
                    //start and stop button
                    Button {
                        if (timerOn){
                            timer.upstream.connect().cancel()
                            timerOn = false
                        }
                        else{
                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                            timerOn = true
                        }
                    } label: {
                        Text(timerOn ? "Pause" : "Start")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 30)
                            .background(
                                timerOn ? Color.orange: Color.yellow
                            )
                            .cornerRadius(5)
                    }
                        
                    Spacer()
                        
                    //restart button
                    Button {
                        reset()
                    } label: {
                        Text("Restart")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 30)
                            .background(Color.pink)
                            .cornerRadius(5)
                    }
                        
                    Spacer()
                        
                } //end of HStack
                .padding(30)
                    
                    
            } //End of VStack
            .toolbar{
                Button {
                    showView = true
                } label: {
                    Image(systemName: "plus")
                        .padding(.trailing, 20)
                }
            }
            .sheet(isPresented: $showView){
                SettingsView(
                    settingsPresented: $showView,
                    workTime: $countTo,
                    restTime: $restTo,
                    cycles: $cycleTo,
                    blockSites: $blockSites,
                    currentCycle: $currentCycle
                )
            }
            .onAppear( //send notification to user
                perform: {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
                    }
                }
            )
    }
        .onReceive(timer){ time in      //constantly count up
            if (timerOn){
                if (working){
                    Counter += 1
                }
                else {
                    secondCounter += 1
                }
                
                if (completed()){   //if work or rest session is over
                    if (working) {   //if work is finished
                        Counter = 0
                        working = false
                        //stop (only when setting written)
                        buttonMessage = !buttonColor
                        buttonColor = buttonMessage
                        timer.upstream.connect().cancel()
                        timerOn = false
                        
                        //show notifications
                        self.notify(type: "Work session finished!")
                    }
                    else {  //if rest is finished
                        secondCounter = 0
                        working = true
                        //stop
                        buttonMessage = !buttonColor
                        buttonColor = buttonMessage
                        timer.upstream.connect().cancel()
                        timerOn = false
                        //update cycle number
                        currentCycle += 1
                        
                        //show notification
                        self.notify(type: "Rest session finished!")
                    }
                }
                
                if (currentCycle == cycleTo){ // entire session finished
                    //stop timer
                    buttonMessage = !buttonColor
                    buttonColor = buttonMessage
                    timer.upstream.connect().cancel()
                    timerOn = false
                    
                    //notify
                    self.notify(type: "All cycles finished!")
                }
            } // end of if
        } // end of .onreceive
        
    } // end of body
    
    
    func notify(type: String) {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "\(type)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req)
        
        
    }
    
    
    func reset(){
        Counter = 0
        secondCounter = 0
        currentCycle = 0
        working = true
        timerOn = false
    }
    
    func completed() -> Bool {
        return progress() == 1
    }
    
    func progress() -> CGFloat {
        if (working) {  //if working
            return (CGFloat(Counter) / CGFloat(countTo))
        }
        else{   //if resting
            return (CGFloat(secondCounter) / CGFloat(restTo))
        }
    }
     
}

struct Clock: View{
    var counter: Int
    var countTo: Int
    
    
    var body: some View{    //struct body
        VStack {
            Text(counterToMinutes())
                .font(.system(size: 60))
                .fontWeight(.black)
        } //end of VStack
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
        
    }
    
}




#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
