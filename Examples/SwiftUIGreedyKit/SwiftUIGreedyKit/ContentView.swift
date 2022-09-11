//
//  ContentView.swift
//  SwiftUIGreedyKit
//
//  Created by Igor Belov on 11.09.2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("Image") {
                    ImageContentView()
                }
                NavigationLink("Video") {
                    EmptyView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
