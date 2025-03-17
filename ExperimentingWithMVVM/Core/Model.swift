//
//  Model.swift
//  ExperimentingWithMVVM
//
//  Created by Conner Yoon on 3/17/25.
//

import Foundation


struct Book : Identifiable {
    var title : String
    var id = UUID()
}

class Library : ObservableObject {
    @Published private(set) var shelf : [Book] = []
    func add(book: Book){
        shelf.append(book)
    }
    func delete(book: Book){
        guard let index = shelf.firstIndex(where: {$0.id == book.id}) else { return
        }
        shelf.remove(at: index)
    }
    func update(book: Book){
        guard let index = shelf.firstIndex(where: {$0.id == book.id}) else { return }
        shelf[index] = book
    }
    func delete(offsets : IndexSet){
        for index in offsets {
            delete(book: shelf[index])
        }
    }
}
import SwiftUI

struct LibraryView : View {
    @ObservedObject var library : Library
    @State var title : String = ""
    var body : some View {
        List {
            TextField("title", text: $title)
            ForEach(library.shelf){ book in
                NavigationLink {
                    BookEditView(book: book, update: library.update)
                } label: {
                    Text(book.title)
                }

                
            }
//            .onDelete(perform: library.delete)
            .onDelete { indexSet in
                library.delete(offsets: indexSet)
            }
            
        }.toolbar {
            Button("Add"){
                library.add(book: Book(title: title))
            }
            
            
        }
    }
}
struct BookEditView : View {
    @State var book : Book
    @Environment(\.dismiss) var dismiss
    var update : (Book) -> ()
//    init(book: Book){//This is what @State does
//        self._book = State(initialValue: book)
//    }
    var body: some View {
        Form{
            TextField("", text: $book.title)
            
        }.toolbar {
            Button("Update"){
                update(book)
                dismiss()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var vm = Library()
    NavigationStack{
        LibraryView(library: vm)
            .navigationTitle("Preview of Library")
    }
}
