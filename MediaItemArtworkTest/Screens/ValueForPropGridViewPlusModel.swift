//
//  ValueForPropGridViewPlusModel.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 6/11/25.
//

import SwiftUI

struct ValueForPropGridViewPlusModel: View {

    @StateObject private var model = AlbumsModel()

    var body: some View {
      ScrollView {
          Label("ValForProp", systemImage: "2.circle")

          LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
              ForEach(model.albums, id: \.persistentID) { album in
                  AlbumThumbnailView(album: album, imageLoader: model.imageLoader)
                      .frame(width: 65, height: 65)
              }
          }
      }
    }
}

#Preview {
    ValueForPropGridViewPlusModel()
}
