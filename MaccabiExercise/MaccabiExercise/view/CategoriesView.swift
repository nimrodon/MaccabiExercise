//
//  ContentView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import SwiftUI

struct CategoriesView: View {
    
    @EnvironmentObject var viewModel: CategoriesViewModel
    
    var body: some View {
        ScrollView {
            if (viewModel.isDataReady) {
                LazyVStack {
                    ForEach(viewModel.categoriesDisplayModel.indices, id: \.self) { index in
                        CategoryCardView(categoryDisplayModel: viewModel.categoriesDisplayModel[index])
                            .padding()
                    }
                }
            }
            else  {
                Text("Loading...")
            }
        }
    }
}

#Preview {
    CategoriesView()
}
