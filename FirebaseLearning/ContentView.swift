//
//  ContentView.swift
//  FirebaseLearning
//
//  Created by Sergei Poluboiarinov on 08.02.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: ViewModel
    
    @State var isAddingNewBook = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.list, id: \.self) { book in
                    NavigationLink {
                        
                    } label: {
                        VStack(alignment: .leading) {
                            Text(book.title)
                            Text(book.author)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("My library")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
