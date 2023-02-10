//
//  NewBookView.swift
//  FirebaseLearning
//
//  Created by Sergei Poluboiarinov on 10.02.2023.
//

import SwiftUI

struct NewBookView: View {
    @EnvironmentObject var model: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    var body: some View {
        Form {
            Text("Add new book to the Library")
                .font(.title)
            Section("Title:") {
                TextField("Title", text: $title)
            }
            Section("Author") {
                TextField("Author", text: $author)
            }
            Section("Genre") {
                TextField("Genre", text: $genre)
            }
            Button("Save") {
                model.addData(title: title, author: author, genre: genre)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .disabled(title.count < 1 || author.count < 1 || genre.count < 1)
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
    }
}
