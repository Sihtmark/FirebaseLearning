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
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var data: Data?
    @State private var selectedItems = [PhotosPickerItem]()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if let data = data, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .padding()
                } else {
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .foregroundColor(.yellow.opacity(0.6))
                        .background(.green)
                        .scaledToFit()
                        .cornerRadius(15)
                        .padding()
                }
                
                Spacer().frame(height: 30)
                
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
                TextField(book.title, text: $title)
                TextField(book.author, text: $author)
                TextField(book.genre, text: $genre)
                Button("Save") {
                    model.updateData(book: book, title: title, author: author, genre: genre, data: data)
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
            downloadImage(url: book.url)
        }
        .padding()
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

//struct BookView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookView(book: sampleBook)
//    }
//}
