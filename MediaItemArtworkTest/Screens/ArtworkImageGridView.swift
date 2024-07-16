//
//  ArtworkImageGridView.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 7/16/24.
//

import SwiftUI
import MediaPlayer

struct ArtworkImageGridView: View {
  
  let albums: [MPMediaItemCollection]
  
  let imageSize = 65 * UIScreen.main.scale

  var body: some View {
    ScrollView {
      Label("ArtImage", systemImage: "1.circle")

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
        ForEach(albums, id: \.persistentID) { album in
          if let image = album.representativeItem?.artwork?.image(at: CGSize(width: imageSize, height: imageSize)) {
            let _ = print("1-", album.representativeItem?.albumTitle ?? "", ":", CFGetRetainCount(image))

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
