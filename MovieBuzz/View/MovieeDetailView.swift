//
//  MovieeDetailView.swift
//  MovieBuzz
//
//  Created by pranay chander on 15/07/23.
//

import SwiftUI

struct MovieeDetailView: View {
    let vm: MovieCellViewModel
    @State private var showingPopover = false
    @State var selectedRating: Rating? = nil
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20)
                            .padding(10)
                    }
                }
                .padding(.top, 5)
                Spacer()
            }
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 10) {
                    AsyncImage(url: URL(string: vm.movie.poster), scale: 2)
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                    Text(vm.movie.title)
                        .font(.largeTitle)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center, spacing: 10) {
                            Text("Genres:")
                                .bold()
                            Text(vm.movie.genre)
                        }
                        HStack(alignment: .center, spacing: 10) {
                            Text("Release Date:")
                                .bold()
                            Text(vm.movie.released)
                        }
                        HStack(alignment: .center, spacing: 10) {
                            Text("Cast and Crew:")
                                .bold()
                            Text(vm.getCastAndCrew())
                        }
                        
                        Text("Synopsis:")
                            .bold()
                        Text(vm.movie.plot)
                        
                        HStack {
                            Text("Rating Source:")
                                .bold()
                            VStack {
                                ForEach(vm.movie.ratings, id: \.self) { rating in
                                    Button(rating.source.rawValue) {
                                        selectedRating = rating
                                        showingPopover = true
                                    }
                                    .alert("\(selectedRating?.source.rawValue ?? ""): \(selectedRating?.value ?? "")", isPresented: $showingPopover) {
                                        Button("OK", role: .cancel) { }
                                    }
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Capsule())
                                }
                            }
                        }
                    }
                    .padding(16)
                    
                }
            }
            .padding()
        }
    }
}
