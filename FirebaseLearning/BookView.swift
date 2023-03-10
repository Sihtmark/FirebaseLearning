//
//  BookView.swift
//  FirebaseLearning
//
//  Created by Sergei Poluboiarinov on 10.02.2023.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct BookView: View {
    
    @EnvironmentObject var model: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var book: Book
    
    @State private var isEditMode = false
    @State private var title = ""
    @State private var author = ""
    @State private var url = ""
    @State private var favorite = false
    @State private var collections = [String]()
    @State private var data: Data?
    @State private var selectedItems = [PhotosPickerItem]()
    
    var body: some View {
        HStack {
            List {
                Section {
                    if isEditMode {
                            HStack {
                                Image(systemName: title.count > 2 ? "checkmark.circle" : "square.and.pencil")
                                    .font(.title3)
                                    .foregroundColor(title.count > 2 ? .green : .black)
                                TextField("Title", text: $title)
                                    .font(.title3)
                            }
                            HStack {
                                Image(systemName: author.count > 2 ? "checkmark.circle" : "square.and.pencil")
                                    .font(.title3)
                                    .foregroundColor(author.count > 2 ? .green : .black)
                                TextField("Author", text: $author)
                                    .font(.title3)
                            }
                    } else {
                        Text(title)
                        Text(author)
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
                        ZStack(alignment: .center) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                            .padding()
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                    }
                    HStack {
                        Spacer()
                        PhotosPicker(data != nil ? "Change picture" : "Add picture", selection: $selectedItems, maxSelectionCount: 1, matching: .images)
                            .onChange(of: selectedItems) { newValue in
                                guard let item = selectedItems.first else {return}
                                item.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let data):
                                        if let data = data {
                                            self.data = data
                                            model.replaceData(book: book, data: data)
                                        } else {
                                            print("Data is nil")
                                        }
                                    case .failure(let failure):
                                        fatalError("\(failure)")
                                    }
                                }
                        }
                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditMode ? "Save" : "Edit") {
                        isEditMode.toggle()
                        if !isEditMode {
                            model.updateData(book: book, title: title, author: author, favorite: favorite, collections: collections)
                        }
                    }
                }
            }
        }
        .onAppear {
            title = book.title
            author = book.author
            url = book.url
            favorite = book.favorite
            collections = book.collections
            downloadImage(url: book.url)
        }
    }
    
    func downloadImage(url: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(url)
        if url != "" {
            fileRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print("We couldn't download image from your Firebase: \(error.localizedDescription)")
                }
                if let data = data {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.data = data
                    }
                }
            }
        } else {
            print("We couldn't download the image because of empty url string!")
        }
    }
}
