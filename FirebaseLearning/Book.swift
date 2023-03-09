//
//  Library.swift
//  FirebaseLearning
//
//  Created by Sergei Poluboiarinov on 08.02.2023.
//

import Foundation

struct Book: Hashable, Identifiable {
    let id: String
    let title: String
    let author: String
    let genre: String
    let url: String
}

let sampleBook = Book(
    id: "GmSnK8KwHX2hnaAEY2PG",
    title: "Lady with a dog",
    author: "Anton Pavlovich Chekhov",
    genre: "fiction",
    url: "images/2B5B72F3-8896-4623-8BEB-3CDA2DED7964.jpg"
)
