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
                        BookView(book: book)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.title3)
                                .bold()
                            Text(book.author)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            model.deleteData(book: book)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                    }
                }
                .onDelete(perform: model.deleteData1)
                .onMove {
                    model.list.move(fromOffsets: $0, toOffset: $1)
                }
            }
            .navigationTitle("My library")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingNewBook.toggle()
                    } label: {
                        Label("Add book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingNewBook) {
                NewBookView()
//                    .presentationDetents([.medium])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
