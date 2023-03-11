//
//  ViewModel.swift
//  FirebaseLearning
//
//  Created by Sergei Poluboiarinov on 08.02.2023.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage

class ViewModel: ObservableObject {
    @Published var list = [Book]()
    @Published var collections = [String]()
    
    init() {
        getData()
    }
    
    func getData() {
        let db = Firestore.firestore()
        db.collection("library").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { doc in
                            for collection in doc["collections"] as? [String] ?? [] {
                                if !self.collections.contains(collection) {
                                    self.collections.append(collection)
                                }
                            }
                            return Book(
                                id: doc.documentID,
                                title: doc["title"] as? String ?? "",
                                author: doc["author"] as? String ?? "",
                                url: doc["url"] as? String ?? "",
                                favorite: doc["favorite"] as? Bool ?? false,
                                collections: doc["collections"] as? [String] ?? []
                            )
                        }
                    }
                }
            } else if let error {
                print("We couldn't get data from the Firestore: \(error.localizedDescription)")
            }
        }
        for book in list {
            for i in book.collections {
                if !collections.contains(i) {
                    collections.append(i)
                }
            }
        }
    }
    
    func addData(title: String, author: String, favorite: Bool, collections: [String], data: Data?) {
        let storage = Storage.storage()
        let db = Firestore.firestore()
        
        guard data != nil else {return}
        let storageRef = storage.reference()
        let refName = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(refName)
        
        db.collection("library").addDocument(data: ["title": title, "author": author, "favorite": favorite, "collections": collections, "url": refName]) { error in
            if error == nil {
                print("We just added new book to the data on the Firebase")
                self.getData()
            } else if let error {
                print("We couldn't add your new book to the data on the Firebase: \(error.localizedDescription)")
            }
        }
        
        fileRef.putData(data!, metadata: nil)
    }
    
    func updateData(book: Book, title: String, author: String, favorite: Bool, collections: [String]) {
        let db = Firestore.firestore()
        db.collection("library").document(book.id).setData(["title": title, "author": author, "favorite": favorite, "collections": collections, "url": book.url, "favorite": favorite, "collections": collections]) { error in
            if error == nil {
                print("We just updated info in your book on the Firestore")
                self.getData()
            } else if let error {
                print("We couldn't update info in your book on the Firestore: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteData1(offsets: IndexSet) {
        for index in offsets {
            deleteData(book: list[index])
        }
    }
    
    func move(indices: IndexSet, newOffset: Int) {
        list.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func deleteData(book: Book) {
        let db = Firestore.firestore()
        db.collection("library").document(book.id).delete { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.list.removeAll { library in
                        return library.id == book.id
                    }
                }
            } else if let error {
                print("We couldn't delete your book from the Firestore: \(error.localizedDescription)")
            }
        }
    }
    
    func replaceData(book: Book, data: Data) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let refName = book.url
        let fileRef = storageRef.child(refName)
        fileRef.delete { error in
            if let error = error {
                print("We cannot delete your old photo: \(error.localizedDescription)")
            } else {
                print("Photo deleted successfully")
            }
        }
        fileRef.putData(data, metadata: nil)
    }
    
    func addToCollections(newCollection: String) {
        if !collections.contains(newCollection) {
            collections.append(newCollection)
        }
    }
}
