//
//  NewsScreen.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import Foundation
import SwiftUI
import NewsAPINetwork

extension Article: Identifiable {
    
    public var id: String { url }
}

final class NewsScreenViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var articles2D: [[Article]] = []
    
    init() {
        ArticlesAPI.everythingGet(q: "apple", from: "2024-03-03", sortBy: "publishedAt", language: "en", apiKey: "apiKey") { data, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            self.articles = data?.articles ?? []
            self.collectArticles2D()
        }
    }
    
    private func collectArticles2D() {
        let columned = articles.publisher.collect(2)
        _ = columned.collect().sink {
            self.articles2D = $0
        }
    }
}

struct NewsScreen: View {
    
    @StateObject var viewModel = NewsScreenViewModel()
    
    var variants = ["List", "Grid", "Grid iOS 13"]
    @State var displayVariant = 0
    
    var body: some View {
        VStack {
            Picker("", selection: $displayVariant) {
                ForEach(0 ..< variants.count, id: \.self) { index in
                    Text(variants[index])
                        .tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            switch displayVariant {
            case 0: list
            case 1: grid
            case 2: gridiOS13
            default: EmptyView()
            }
        }
    }
    
    var list: some View {
        List(viewModel.articles) { article in
            ListArticleCell(
                title: article.title ?? "",
                description: article.description ?? ""
            )
        }
    }
    
    var grid: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(), count: 2), content: {
                ForEach(viewModel.articles) { article in
                    ListArticleCell(
                        title: article.title ?? "",
                        description: article.description ?? ""
                    )
                }
            })
            .padding(.horizontal, 20)
        }
    }
    
    var gridiOS13: some View {
        ScrollView {
            VStack(spacing: 8, content: {
                ForEach(0..<viewModel.articles2D.count, id: \.self) { row in
                    HStack(spacing: 8, content: {
                        ForEach(viewModel.articles2D[row]) { article in
                            ListArticleCell(
                                title: article.title ?? "",
                                description: article.description ?? ""
                            )
                        }
                    })
                }
            })
            .padding(.horizontal, 20)
        }
    }
}

struct ListArticleCell: View {
    
    let title: String
    let description: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.gray)
            VStack {
                Text(title.isEmpty ? description : title)
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
    }
    
}

#Preview {
    NewsScreen()
}
