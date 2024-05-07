//
//  Components.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 07/05/2024.
//

import SwiftUI

struct DisplayImage: View {
    
    var imageURL: String
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Text("Loading image...")
        }
        .frame(width: width, height: height)
        .cornerRadius(20)
    }
}

