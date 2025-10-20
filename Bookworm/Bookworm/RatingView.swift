//
//  RatingView.swift
//  Bookworm
//
//  Created by Deepankar Das on 14/10/25.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    private let maximumRating = 5
    
    var label = ""
    
    var offImage : Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    var body: some View {
        HStack{
            if label.isEmpty == false {
                   Text(label)
               }
            ForEach(1...maximumRating, id: \.self) { number in
                Button{
                    rating = number
                }label: {
                    image(for: number)
                        .foregroundColor(number > rating ? offColor : onColor)
                }
            }.buttonStyle(.plain)
        }
    }
    func image(for number: Int) -> Image {
        if number > rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
}

#Preview {
    RatingView(rating: .constant(3))
}
