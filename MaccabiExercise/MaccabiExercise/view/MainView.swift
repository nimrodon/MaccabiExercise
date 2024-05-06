//
//  MainView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 06/05/2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: CategoriesViewModel
    
    var body: some View {
        if (viewModel.isDataReady) {
            CategoriesView()
        }
        else {
            Text("Loading...")
        }
    }
}

#Preview {
    MainView()
}
