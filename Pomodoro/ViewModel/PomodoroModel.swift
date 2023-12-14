//
//  PomodoroModel.swift
//  Pomodoro
//
//  Created by Ezgi on 12.12.2023.
//

import SwiftUI
import UserNotifications

class PomodoroModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // timer'ın özellikleri
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    // zamanlayıcının bildirim ayarları
    @Published var isFinished: Bool = false
    
    // since its nsobject
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    // requesting bildirimleri
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.badge]) { _, _ in
        }
        // bildirimleri uygulamada göstermek için kullandık
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    }
    
    //toplam dakikayı hesaplamak
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    
    
    // zamanlayıcıya burada başladık
    func startTimer(){
        withAnimation(.easeInOut(duration: 0.25)){isStarted = true}
        // String zaman ayarları
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ?"\(minutes)":"0\(minutes)"):\(seconds >= 10 ?"\(seconds)":"0\(seconds)")"
        // toplam dakikayı hesaplamak için zamanlayıcı animasyonu
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    // zamanlayıcı burada durdurduk
    func stopTimer(){
        withAnimation{
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
         
    }
    
    //Updating Timer
    func updateTimer(){
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress )
        
        // 60 dakika * 60 saniye
        
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ?"\(minutes)":"0\(minutes)"):\(seconds >= 10 ?"\(seconds)":"0\(seconds)")"
        if hour == 0 && seconds == 0 && minutes == 0 {
            isStarted = false
            print("Süre doldu!")
            isFinished = true
        }
    }
    func addNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Zamanlayıcı"
        content.subtitle = "Süre doldu"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        UNUserNotificationCenter.current().add(request)
    }



