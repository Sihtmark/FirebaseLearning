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
            Section("Image") {
                if let data = data, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(15)
                        .padding()
                } else {
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(15)
                        .padding()
                }
                PhotosPicker("Set image", selection: $selectedItems, maxSelectionCount: 1,matching: .images)
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
