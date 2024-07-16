//
//  ValueForPropGridView.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 7/16/24.
//

import SwiftUI
import MediaPlayer

struct ValueForPropGridView: View {
  
  let albums: [MPMediaItemCollection]
  
  var body: some View {
    ScrollView {
      Label("ValForProp", systemImage: "2.circle")

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
        ForEach(albums, id: \.persistentID) { album in
          if let artwork = album.representativeItem?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork,
             let image = artwork.image(at: artwork.bounds.size) {
            let _ = print("2-", album.representativeItem?.albumTitle ?? "", ":", CFGetRetainCount(artwork), CFGetRetainCount(image))

            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fit)
            
          } else {
            Color.gray
          }
        }
      }
    }
  }
}
