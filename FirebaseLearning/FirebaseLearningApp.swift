//
//  FirebaseLearningApp.swift
//  FirebaseLearning
//
//  Created by Sergei Poluboiarinov on 08.02.2023.
//

import SwiftUI
import Firebase

@main
struct FirebaseLearningApp: App {
    
    @StateObject private var model = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
