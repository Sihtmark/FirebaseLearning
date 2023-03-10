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
    @State private var favorite = false
    @State private var collections = [String]()
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var data: Data?
    @State private var newCollection = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Book info:") {
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
                }
                Section("Collections:") {
                    ForEach(model.collections, id: \.self) { collection in
                        Button {
                            addToCollections(collection: collection)
                        } label: {
                            HStack {
                                Image(systemName: collections.contains(collection) ? "checkmark.circle" : "circle")
                                Text(collection)
                            }
                        }

                    }
                    HStack {
                        TextField("Add new collection", text: $newCollection)
                        Button("Add") {
                            addToCollections(collection: newCollection)
                            model.addToCollections(newCollection: newCollection)
                            newCollection = ""
                        }
                        .disabled(newCollection.count < 1)
                    }
                }
                Section("Picture:") {
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
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            favorite.toggle()
                        } label: {
                            Image(systemName: favorite ? "star.fill" : "star")
                        }
                        Button("Save") {
                            model.addData(title: title, author: author, favorite: favorite, collections: collections, data: data)
                            dismiss()
                        }
                        .disabled(title.count < 2 || author.count < 2 || data == nil)
                    }
                    

                }
            }
        }
    }
    
    func addToCollections(collection: String) {
        if !collections.contains(collection) {
            collections.append(collection)
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView().environmentObject(ViewModel())
    }
}
