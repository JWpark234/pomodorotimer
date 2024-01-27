//
//  pomotimerApp.swift
//  pomotimer
//
//  Created by Jinwoo Park on 2024/01/10.
//

import SwiftUI
import SwiftData


@main
struct pomotimerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }() // ignore this shit

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    
                } // when app launches
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    // App will resign active (e.g. goes to the background)
                    // Perform necessary tasks
                }
                .onChange(of: scenePhase) { _, newScenePhase in
                    if newScenePhase == .background || newScenePhase == .inactive {
                        // App goes to the background or enters inactive state (e.g., switching to another app)
                        
                        
                        //VARIABLES
                        //booleans
                        @AppStorage("working") var working: Bool = true
                        @AppStorage("timerOn") var timerOn: Bool = false
                        @AppStorage("shouldStop") var shouldStop: Bool = true
                        
                        //counters and limits
                        @AppStorage("counter") var Counter: Int = 0
                        @AppStorage("secondCounter") var secondCounter: Int = 0
                        @AppStorage("workTime") var countTo: Int = 25
                        @AppStorage("restTime") var restTo: Int = 25
                        
                        //cycles
                        @AppStorage("currentCycle") var currentCycle: Int = 0
                        @AppStorage("cycleTo") var cycleTo: Int = 0
                        
                        
                        
                        while (timerOn){
                            if (working){
                                Counter += 1
                            }
                            else {
                                secondCounter += 1
                            }
                            
                            //if work or rest session is over, stop and switch around
                            if (working ? (Counter >= countTo) : (secondCounter >= restTo)){
                                if (working) {   //if work is finished
                                    Counter = 0
                                    working = false
                                    //show notifications
                                    notify(type: "Work session finished!")
                                }
                                else {  //if rest is finished
                                    secondCounter = 0
                                    working = true
                                    
                                    //update cycle number
                                    currentCycle += 1
                                    
                                    //show notification
                                    self.notify(type: "Rest session finished!")
                                }
                                
                                if (shouldStop){
                                    //stop (only when setting written)
                                    timerOn = false
                                }
                                
                                if (currentCycle >= cycleTo){
                                    currentCycle = 0
                                    timerOn = false
                                    notify(type: "All work cycles finished! Time to take a break :D")
                                }
                            }
                            
                            //update notification
                            //(PLACEHOLDER)
                            
                            sleep(1)
                        } // end of while loop
                        
                        
                        
                        
                        
                    } else if newScenePhase == .active {
                        // App becomes active (e.g., coming back from another app)
                            
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    func timerAction() {
        print("Code executed every second")
        // Add your code here that you want to run every second
    }
                                
    func notify(type: String) {
        let content = UNMutableNotificationContent()
        content.title = "\(type)"
        content.sound = .default
        content.badge = 1
                                    
                                    
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                    
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
                                    
        UNUserNotificationCenter.current().add(req)
    }
}



