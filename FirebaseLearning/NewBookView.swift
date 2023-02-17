//
//  NewBookView.swift
//  FirebaseLearning
//
//  Created by Sergei Poluboiarinov on 10.02.2023.
//

import SwiftUI
import PhotosUI

struct NewBookView: View {
    @EnvironmentObject var model: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var data: Data?
    var body: some View {
        Form {
            Section("") {
                Text("Add new book to the Library")
                    .font(.title)
                HStack {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(title.count > 2 ? .green : .black)
                    TextField("Title", text: $title)
                }
                HStack {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(author.count > 2 ? .green : .black)
                    TextField("Author", text: $author)
                }
                HStack {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(genre.count > 2 ? .green : .black)
                    TextField("Genre", text: $genre)
                }
            }
            Section {
                if let data = data, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(15)
                        .padding()
                } else {
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .foregroundColor(.yellow.opacity(0.6))
                        .background(.green)
                        .scaledToFill()
                        .cornerRadius(15)
                        .padding()
                }
                PhotosPicker("Set image", selection: $selectedItems, maxSelectionCount: 1, matching: .images)
                    .onChange(of: selectedItems) { newValue in
                        guard let item = selectedItems.first else {return}
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.data = data
                                } else {
                                    print("Data is nil")
                                }
                            case .failure(let failure):
                                fatalError("\(failure)")
                            }
                        }
                    }
            }
            VStack {
                Button("Save") {
                    model.addData(title: title, author: author, genre: genre, data: data)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.count < 2 || author.count < 2 || genre.count < 2 || data == nil)
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.yellow)
                        .font(.title2)
                    Text("All fields must be filled\nImage must be set")
                        .foregroundColor(.yellow)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
    }
}
