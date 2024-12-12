//
//  ContentView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var taxonSelected: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack() {
                Text("Filter")
            
                Text("owl")
                    .font(.title3)
                    .cornerRadius(10)
                    .padding()
                    .frame(height: 40)
                    .foregroundStyle(taxonSelected ? Color.white : Color.accentColor)
                    .background(taxonSelected ? Color.accentColor : Color.white)
                    .border(Color.accentColor)
                    .onTapGesture {
                        taxonSelected.toggle()
                    }
                
                Spacer()
                
                NavigationLink(destination: ObservationListView()) {
                    Text("Search")
                        .font(.title2)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding()
                }
                .navigationTitle("Filter")
            }
        }
    }
}

#Preview {
    ContentView()
}
