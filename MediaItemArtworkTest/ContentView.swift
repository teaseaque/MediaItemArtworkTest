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
  
  @State var albums: [MPMediaItemCollection] = []

  var body: some View {
    TabView {
      ArtworkImageGridView(albums: $albums.wrappedValue)
        .tabItem {
            Label("ArtImage", systemImage: "1.circle")
        }

      ValueForPropGridView(albums: $albums.wrappedValue)
        .tabItem {
            Label("ValForProp", systemImage: "2.circle")
        }
      
      ImageFromDiskGridView(albums: $albums.wrappedValue)
        .tabItem {
            Label("ImageFromDisk", systemImage: "3.circle")
        }

      AlbumGridRepresentable(albums: $albums.wrappedValue)
        .tabItem {
            Label("UIKit", systemImage: "4.circle")
        }

      ValueForPropGridViewPlusModel()
        .tabItem {
            Label("ValForPropModel", systemImage: "5.circle")
        }
    }
    .onAppear {
      if isAuthorized {
        albums = MPMediaQuery.albums().collections ?? []

      } else {
        MPMediaLibrary.requestAuthorization { newStatus in
          if newStatus == .authorized {
            albums = MPMediaQuery.albums().collections ?? []
          }
        }
      }
    }
  }
}
