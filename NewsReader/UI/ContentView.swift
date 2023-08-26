//
//  ContentView.swift
//  NewsReader
//
//  Created by MacBook on 25/08/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        ListView(viewModel: ListView.ViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
