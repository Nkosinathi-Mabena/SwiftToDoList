//
//  SegmentsCardView.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/08/27.
//

import SwiftUI

struct SegmentsCard: View {
    var icon: String
    var title: String
    var count: Int
    
    var body: some View {
        HStack (spacing:10){
            VStack(alignment: .leading, spacing:5){
                Image(systemName: icon)
                    .font(.system(size:18))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.black))

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontWeight(.heavy)
                    .lineLimit(1)          // only 1 line
            }
            
            Spacer()
            
            HStack{
                Text("\(count)")
                    .font(.system(size: 30))
                    .fontWeight(.heavy)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
