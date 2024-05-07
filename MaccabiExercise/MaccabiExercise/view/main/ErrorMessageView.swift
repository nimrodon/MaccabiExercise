//
//  ErrorMessageView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 06/05/2024.
//

import SwiftUI

struct ErrorMessageView: View {
    
    @EnvironmentObject var viewModel: ProductsViewModel
    
    var errorMessage: String
    var showRetryButton: Bool


    var body: some View {
        VStack {
            Text("Loading data failed:")
            Text(errorMessage)
            if (showRetryButton) {
                Button ("Retry", action: viewModel.retryFetchProducts)
            }
        }
    }
}

#Preview {
    ErrorMessageView(errorMessage: "Computer temperature high!", showRetryButton: true)
}
