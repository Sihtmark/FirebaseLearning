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
