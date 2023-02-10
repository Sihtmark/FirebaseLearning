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
}

let sampleBook = Book(
    id: "pojnpojp[qwjef",
    title: "Lady with a dog",
    author: "Anton Pavlovich Chekhov",
    genre: "fiction")
