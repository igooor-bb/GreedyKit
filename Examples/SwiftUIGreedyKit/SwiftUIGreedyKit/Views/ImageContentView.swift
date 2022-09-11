//
//  ImageContentView.swift
//  SwiftUIGreedyKit
//
//  Created by Igor Belov on 11.09.2022.
//

import SwiftUI
import GreedyKit

struct ImageContentView: View {
    @State private var preventsCapture: Bool = false
    
    private let localImage: UIImage = {
        guard
            let path = Bundle.main.path(forResource: "image", ofType: "jpg"),
            let image = UIImage(contentsOfFile: path)
        else {
            fatalError("Test image is missing in the bundle")
        }
        return image
    }()
    
    var body: some View {
        VStack {
            GreedyImage(localImage, preventsCapture: preventsCapture)
                .frame(height: 400)
            Toggle(isOn: $preventsCapture) {
                Text("Protection is " + (preventsCapture ? "ON" : "OFF"))
            }
        }
        .padding(16)
    }
}

struct ImageContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageContentView()
    }
}
