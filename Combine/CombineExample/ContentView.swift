//
//  ContentView.swift
//  Combine
//
//  Created by Neosoft on 09/09/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ProductViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            viewModel.getProductData()
        }
        
    }
}

#Preview {
    ContentView()
}
