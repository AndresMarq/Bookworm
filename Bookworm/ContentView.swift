//
//  ContentView.swift
//  Bookworm
//
//  Created by Andres Marquez on 2021-07-15.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
            NavigationView {
                List {
                    ForEach(books, id: \.self) { book in
                        NavigationLink(destination: DetailView(book: book)) {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                    .foregroundColor(book.rating > 1 ? Color.black : Color.red)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: removeBook)
                }
                    .navigationBarTitle("Bookworm")
                    
                .navigationBarItems(leading: EditButton(),trailing: Button(action: {
                        self.showingAddScreen.toggle()
                    }) {
                        Image(systemName: "plus")
                    })
                    .sheet(isPresented: $showingAddScreen) {
                        AddBookView().environment(\.managedObjectContext, self.moc)
                    }
            }
    }
    
    func removeBook(at offsets: IndexSet) {
        for index in offsets {
            let book = books[index]
            PersistenceController.shared.delete(book)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
