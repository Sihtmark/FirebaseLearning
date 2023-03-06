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
    
    init() {getData()}
    
    func getData() {
        let db = Firestore.firestore()
        db.collection("library").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { doc in
                            return Book(
                                id: doc.documentID,
                                title: doc["title"] as? String ?? "",
                                author: doc["author"] as? String ?? "",
                                genre: doc["genre"] as? String ?? "",
                                url: doc["url"] as? String ?? ""
                            )
                        }
                    }
                }
            } else if let error {
                print("We couldn't get data from the Firestore: \(error.localizedDescription)")
            }
        }
    }
    
    func addData(title: String, author: String, genre: String, data: Data?) {
        let storage = Storage.storage()
        let db = Firestore.firestore()
        
        guard data != nil else {return}
        let storageRef = storage.reference()
        let refName = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(refName)
        
        db.collection("library").addDocument(data: ["title": title, "author": author, "genre": genre, "url": refName]) { error in
            if error == nil {
                print("We just added new book to the data on the Firebase")
                self.getData()
            } else if let error {
                print("We couldn't add your new book to the data on the Firebase: \(error.localizedDescription)")
            }
        }
        
        fileRef.putData(data!, metadata: nil)
    }
    
    func updateData(book: Book, title: String, author: String, genre: String, oldUrl: String, data: Data?) {
        var oldData: Data?
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(oldUrl)
        if oldUrl != "" {
            fileRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print("We couldn't download image from your Firebase: \(error.localizedDescription)")
                }
                if let data = data {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        oldData = data
                    }
                }
            }
        } else {
            print("We couldn't download the image because of empty url string!")
        }
        if oldData != data {
            let refName = "images/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(refName)
            storageRef.child(oldUrl).delete { error in
                if let error = error {
                    print("We cannot delete your old photo: \(error.localizedDescription)")
                } else {
                    print("Photo deleted successfully")
                }
            }
            fileRef.putData(data!, metadata: nil)
            
            db.collection("library").document(book.id).setData(["title": title, "author": author, "genre": genre, "url": refName]) { error in
                if error == nil {
                    print("We just updated info in your book on the Firebase")
                    self.getData()
                } else if let error {
                    print("We couldn't update info in your book on the Firebase: \(error.localizedDescription)")
                }
            }
        } else {
            db.collection("library").document(book.id).setData(["title": title, "author": author, "genre": genre, "url": oldUrl]) { error in
                if error == nil {
                    print("We just updated info in your book on the Firebase")
                    self.getData()
                } else if let error {
                    print("We couldn't update info in your book on the Firebase: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteData1(offsets: IndexSet) {
        for index in offsets {
            deleteData(book: list[index])
        }
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
}
