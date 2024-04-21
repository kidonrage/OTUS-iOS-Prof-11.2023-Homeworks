//
//  InputView.swift
//  Homework
//
//  Created by Vlad Eliseev on 21.04.2024.
//

import SwiftUI

struct InputScreen: View {
    
    @State var input: String = ""
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Через пробел")
            TextField(text: $input, label: {
                Text("Сюда")
            })
            .frame(height: 40.0)
            .padding(.horizontal , 8)
            .overlay(
               RoundedRectangle(cornerRadius: 5)
                   .stroke(Color.gray.opacity(0.3), lineWidth: 1)
           )
            Button(action: {
                appRouter.path.append(.results(input: input))
            }, label: {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Подтвердить")
                    Spacer()
                }
            })
            .padding()
        }
        .padding(.horizontal, 8)
        .navigationTitle("Введите слова")
    }
}

#Preview {
    InputScreen()
}
