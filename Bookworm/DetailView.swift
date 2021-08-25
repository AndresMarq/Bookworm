//
//  DetailView.swift
//  Bookworm
//
//  Created by Andres Marquez on 2021-07-16.
//
//Pictures by Ryan Wallace, Eugene Triguba, Jamie Street, Alvaro Serrano, Joao Silas, David Dilbert, and Casey Horner – you can get the originals from https://unsplash.com if you want.

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()
    
    let book: Book
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(width: geo.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(self.book.review ?? "No review")
                    .padding()

                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                Text("Added on: \(self.book.date ?? Date(), formatter: dateFormatter)")
                    .font(.footnote)
                    .padding()

                Spacer()
            }
            .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
            .alert(isPresented: $showingDeleteAlert) {
                Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .default(Text("Delete")) { deleteBook() }, secondaryButton: .cancel())
            }
            .navigationBarItems(trailing: Button(action: {
                self.showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
            })
        }
    }
    
    func deleteBook() {
        PersistenceController.shared.delete(book)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        static var previews: some View {
            let book = Book(context: moc)
            book.title = "Test book"
            book.author = "Test author"
            book.genre = "Fantasy"
            book.rating = 4
            book.review = "This was a great book; I really enjoyed it."

            return NavigationView {
                DetailView(book: book)
            }
        }
}
