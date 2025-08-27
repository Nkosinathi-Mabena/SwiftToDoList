//
//  WeatherView.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/12.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel(repository: WeatherRepository())
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
            WeatherView()
    }
}
