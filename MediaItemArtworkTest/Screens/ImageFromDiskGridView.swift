//
//  ImageFromDiskGridView.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 7/16/24.
//

import SwiftUI
import MediaPlayer

struct ImageFromDiskGridView: View {
  
  let albums: [MPMediaItemCollection]
  
  let selector = NSSelectorFromString("bestImageFromDisk")

  var body: some View {
    ScrollView {
      Label("ImageFromDisk", systemImage: "3.circle")

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
        ForEach(albums, id: \.persistentID) { album in
          if let artObject = album.value(forKey: "artworkCatalog") as? NSObject,
             artObject.responds(to: selector),
             let value = artObject.perform(selector)?.takeUnretainedValue(),
             let image = value as? UIImage {
            let _ = print("3-", album.representativeItem?.albumTitle ?? "", ":", CFGetRetainCount(artObject), CFGetRetainCount(value), CFGetRetainCount(image))

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
