//
//  AlbumThumbnailView.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 6/11/25.
//

import SwiftUI
import MediaPlayer

struct AlbumThumbnailView: View {
    let album: MPMediaItemCollection
    @ObservedObject var imageLoader: AlbumImageLoader

    var body: some View {
        Group {
            if let image = imageLoader.image(for: album.persistentID) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .onAppear {
                        imageLoader.loadImage(for: album)
                    }
            }
        }
        .frame(width: 65, height: 65)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .onAppear {
            imageLoader.markVisible(album.persistentID)
        }
        .onDisappear {
            imageLoader.markInvisible(album.persistentID)
        }
    }
}
