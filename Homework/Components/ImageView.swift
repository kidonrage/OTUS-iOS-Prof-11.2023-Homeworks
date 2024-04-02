//
//  ImageView.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import Foundation
import SwiftUI

struct ImageView: UIViewRepresentable {
    
    @Binding var imageName: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = UIImage(named: imageName)
    }
}
