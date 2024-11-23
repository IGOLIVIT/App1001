//
//  ContentView.swift
//  App1001
//
//  Created by IGOR on 11/11/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var current_tab: Tab = Tab.Home

    @State var isFetched: Bool = false
    
    @State var isBlock: Bool = true
    @State var isDead: Bool = false

    @AppStorage("status") var status: Bool = false
    
    init() {
        
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            if isFetched == false {
                
                LoadingView()
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
                    if status {
                        
                        VStack(spacing: 0, content: {
                        
                                TabView(selection: $current_tab, content: {

                                    HomeView()
                                        .tag(Tab.Home)

                                    StaffView()
                                        .tag(Tab.Staff)
                                    
                                    PriceView()
                                        .tag(Tab.Price)
                                    
                                    SettingsView()
                                        .tag(Tab.Settings)
                                    
                                })
                                
                                TabBar(selectedTab: $current_tab)
                            })
                                .ignoresSafeArea(.all, edges: .bottom)
                                .onAppear {
                                    
                                }
                    } else {
                        
                        Rev1()
                    }
                    
                } else if isBlock == false {
                    
                    if status {
                        
                        WebSystem()
                        
                    } else {
                        
                        U1()
                    }
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = DataManager().lastDate
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive

        guard now > targetDate else {

            isBlock = true
            isFetched = true

            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
    }
}

#Preview {
    ContentView()
}
