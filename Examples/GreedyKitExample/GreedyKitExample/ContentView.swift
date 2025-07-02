//
//  ContentView.swift
//  GreedyKitExample
//
//  Created by Igor Belov on 02.07.2025.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            List {
                Section("UIKit \(Image(systemName: "square.stack.3d.down.right"))") {
                    NavigationLink("GreedyImageView") {
                        AnyViewControllerRepresentable<ImageViewController>()
                    }

                    NavigationLink("GreedyPlayerView") {
                        AnyViewControllerRepresentable<VideoViewController>()
                    }
                }

                Section("SwiftUI \(Image(systemName: "swift"))") {
                    NavigationLink("GreedyImage") {
                        ImageContentView()
                    }
                    NavigationLink("GreedyPlayer") {
                        VideoContentView()
                    }
                }
            }
            .navigationTitle("GreedyKit")
        }
    }
}

#Preview {
    ContentView()
}
