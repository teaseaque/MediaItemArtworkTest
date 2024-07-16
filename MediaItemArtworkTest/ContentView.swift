//
//  ContentView.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 7/16/24.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
  
  var isAuthorized: Bool = { MPMediaLibrary.authorizationStatus() == .authorized }()
  
  @State var albums: MPMediaQuery?
  
  var body: some View {
    TabView {
      ArtworkImageGridView(albums: $albums.wrappedValue?.collections ?? [])
        .tabItem {
            Label("ArtImage", systemImage: "1.circle")
        }

      ValueForPropGridView(albums: $albums.wrappedValue?.collections ?? [])
        .tabItem {
            Label("ValForProp", systemImage: "2.circle")
        }
      
      ImageFromDiskGridView(albums: $albums.wrappedValue?.collections ?? [])
        .tabItem {
            Label("ImageFromDisk", systemImage: "3.circle")
        }
    }
    .onAppear {
      if isAuthorized {
        albums = MPMediaQuery.albums()

      } else {
        MPMediaLibrary.requestAuthorization { newStatus in
          if newStatus == .authorized {
            albums = MPMediaQuery.albums()
          }
        }
      }
    }
  }
}

#Preview {
    ContentView()
}
