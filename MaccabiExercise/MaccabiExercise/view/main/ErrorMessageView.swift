//
//  ErrorMessageView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 06/05/2024.
//

import SwiftUI

struct ErrorMessageView: View {
    
    @EnvironmentObject var viewModel: ProductsViewModel
    
    var errorTitle: String
    var errorMessage: String
    var showRetryButton: Bool

    var body: some View {
        VStack {
            
            Text(errorTitle)
                .font(.headline)
                .foregroundColor(.red)

            Text(errorMessage)
                .multilineTextAlignment(.center)
                .padding()

            if showRetryButton {
                Button("Retry", action: viewModel.retryFetchProducts)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
            }
        }
        .outlineFrame()
    }
}

#Preview {
    ErrorMessageView(errorTitle: "Loading products failed", errorMessage: "Computer temperature high!", showRetryButton: true).environmentObject(ProductsViewModel(ProductsService()))
}
