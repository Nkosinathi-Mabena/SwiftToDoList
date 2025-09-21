//
//  ForecastIconView.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/09/20.
//
import SwiftUI

struct ForecastIconView: View {
    let iconURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: iconURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(height: 30)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            case .failure:
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            @unknown default:
                EmptyView()
            }
        }
    }
}
