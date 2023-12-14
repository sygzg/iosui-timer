//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Ezgi on 12.12.2023.
//

import SwiftUI

@main
struct PomodoroApp: App {
    @StateObject var pomodoroModel: PomodoroModel = .init() // başlatıcıyı çağırdık
    
    // uygulamadan çıkınca
    @Environment(\.scenePhase) var phase
    
    //storing last timer stamp
    @State var lastActiveTimeStamp: Date = Date()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroModel)
        }
        .onChange(of: phase) {newValue in
            if pomodoroModel.isStarted{
                if newValue == .background{
                    lastActiveTimeStamp = Date()
                    
                }
                if newValue == .active{
                    // farkı bulmak için
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if $pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        pomodoroModel.isStarted = false
                        $pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                        
                    }else{
                        $pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
                
            }
            
        }
    }
}


























