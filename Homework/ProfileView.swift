//
//  ProfileView.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    
    @State var avatarName = "avatar"
    
    var body: some View {
        VStack {
            ImageView(imageName: $avatarName)
                .frame(width: 300, height: 300, alignment: .center)
            Text("Аноним Анонимусович")
        }
    }
}
