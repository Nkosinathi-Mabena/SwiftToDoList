//
//  TabBarView.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/11.
//

import SwiftUI

struct TabBarView: View{

    var body: some View{
        TabView(){
            ToDoView(viewModel:DIContainer.shared.resolveTaskViewModel())
                .tabItem{
                    Image(systemName: "doc.plaintext")
                    Text("Tasks")
                }
                .tag(0)
            
            WeatherView(viewModel: DIContainer.shared.resolveWeatherViewModel() as! WeatherViewModel)
                .tabItem{
                    Image(systemName: "cloud.drizzle.fill")
                    Text("Weather")
                }
                .tag(1)
            
            NotificationSettingsView(viewModel: DIContainer.shared.resolveTaskViewModel())
                .tabItem{
                    Image(systemName: "bell.fill")
                    Text("Settings")
                }
                .tag(2)
        }
    }
}

#Preview {
    TabBarView()
}
