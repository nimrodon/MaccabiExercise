//
//  MainView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 06/05/2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: ProductsViewModel
    
    var body: some View {
        if viewModel.isDataReady {
            NavigationView {
                VStack {
                    CategoriesView()
                }
            }
        }
        else {
            if viewModel.errorMessage != nil {
                ErrorMessageView(errorMessage: viewModel.errorMessage!,
                                 showRetryButton: viewModel.showRetryButton)
            }
            else {
                Text("Loading...")
            }
        }
    }
}

#Preview {
    MainView()
}
