//
//  BookView.swift
//  FirebaseLearning
//
//  Created by Sergei Poluboiarinov on 10.02.2023.
//

import SwiftUI

struct BookView: View {
    @EnvironmentObject var model: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var book: Book
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if isEditing {
                    TextField(book.title, text: $title)
                    TextField(book.author, text: $author)
                    TextField(book.genre, text: $genre)
                } else {
                    Text(title)
                    Text(author)
                    Text(genre)
                    Button("Save") {
                        model.updateData(book: book, title: title, author: author, genre: genre)
                        dismiss()
                    }
                    .disabled(title.count < 3 || author.count < 3 || genre.count < 3)
                    .buttonStyle(.borderedProminent)
                }
            }
            .onAppear {
                title = book.title
                author = book.author
                genre = book.genre
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Done" : "Edit") {
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: sampleBook)
    }
}
