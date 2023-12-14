//
//  Home.swift
//  Pomodoro
//
//  Created by Ezgi on 12.12.2023.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        VStack{
            Text("Pomodoro")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            GeometryReader{proxy in
                VStack(spacing: 15){
                    
                    //Zamanlayıcı halkası
                    ZStack{
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.03), lineWidth: 80)
                            .padding(-40)
                        
                        //Gölgelendirme
                        Circle()
                            .stroke(Color("lightbrown"),lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                        Circle()
                            .fill(Color("Background"))
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(Color("lightbrown").opacity(0.7),lineWidth: 10)
                        
                        // Knob(top) kısmının yapılışı
                        GeometryReader{proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("lightbrown"))
                                .frame(width: 30, height: 30)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .blur(radius: 3.2)
                                        .padding(5)
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                            
                        }
                        
                        Text(pomodoroModel.timerStringValue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: pomodoroModel.progress)
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: pomodoroModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    
                    Button {
                        if pomodoroModel.isStarted {
                            pomodoroModel.stopTimer()
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        } else {
                            pomodoroModel.startTimer()
                        }
                    } label: {
                        Image(systemName: pomodoroModel.isStarted ? "stop.fill" : "timer")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Circle().fill(Color("lightbrown")))
                            .shadow(color: Color("lightbrown"), radius: 6, x: 0, y: 0)
                    }

                }
                .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
        }
        .padding()
        .background{
            Color("Background")
                .ignoresSafeArea()
        }
        .overlay(content: {
            ZStack{
                Color.black
                    .opacity(pomodoroModel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        pomodoroModel.hour = 0
                        pomodoroModel.minutes = 0
                        pomodoroModel.seconds = 0
                        pomodoroModel.addNewTimer = false 
                    }
                
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: pomodoroModel.addNewTimer ? 0: 400)
            }
            .animation(.easeInOut, value: pomodoroModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()){
           _ in
            if pomodoroModel.isStarted{
                pomodoroModel.updateTimer()
                
            }
        }
        .alert("Süre doldu", isPresented: $pomodoroModel.isFinished) {
            Button("Start New",role: .cancel){
                pomodoroModel.stopTimer()
                pomodoroModel.addNewTimer = true
                
            }
            Button ("Close", role: .destructive){
                $pomodoroModel.stopTimer()
            }
        }
    }
    
    // Zamanlayıcının alt kısmı
    @ViewBuilder
    func NewTimerView() -> some View{
        VStack(spacing: 15){
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top,10)
            
            
            HStack(spacing: 15){
                
                Text("\(pomodoroModel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal)
                    .padding(.vertical,12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 12, hint: "hr"){value in
                            pomodoroModel.hour = value
                        }
                    }
                
                Text("\(pomodoroModel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal)
                    .padding(.vertical,12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "min" ){value in
                            pomodoroModel.minutes = value
                        }
                    }
                
                Text("\(pomodoroModel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal)
                    .padding(.vertical,12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "sec"){value in
                            pomodoroModel.seconds = value
                        }
                    }
                
            }
            .padding(.top, 20)
            
            Button{
                $pomodoroModel.startTimer
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,100)
                    .background{
                        Capsule()
                            .fill(Color("bej"))
                    }
            }
            .disabled(pomodoroModel.seconds == 0)
            .opacity(pomodoroModel.seconds == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("Background"))
                .ignoresSafeArea()
        }
        
    }
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }
    
    struct Home_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(PomodoroModel())
        }
    }
}
