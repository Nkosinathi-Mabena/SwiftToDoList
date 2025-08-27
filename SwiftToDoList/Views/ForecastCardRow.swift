//
//  ForecastCardView.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/12.
//

import SwiftUI

struct ForecastCardRow: View {

}


struct ForecastCardRow_Previews: PreviewProvider {
    static var previews: some View {
        let mockForecasts = [
            Forecast(temperature: 23,description: "Sunny",date: Date(),sunrise: Date(),sunset: Date(),icon: .sunny
            ),
            Forecast(temperature: 21,description: "Cloudy",date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,sunrise: Date(),sunset:Date(),icon: .cloudy
            ),
            Forecast(temperature: 19,description: "Rainy",date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,sunrise: Date(),sunset:Date(),icon: .rain
            )
        ]
        
        ForecastCardRow(forecasts: mockForecasts)
            .previewLayout(.sizeThatFits)
    }
}
