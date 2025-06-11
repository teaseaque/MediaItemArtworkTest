//
//  AlbumsModel.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 6/11/25.
//

import SwiftUI
import MediaPlayer

@MainActor
class AlbumsModel: ObservableObject {
    @Published var albums: [MPMediaItemCollection] = []
    let imageLoader = AlbumImageLoader()

    init() {
        Task {
            await requestAuthorization()
        }
    }

    private func requestAuthorization() async {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            loadAlbums()
        } else {
            let status = await withCheckedContinuation { continuation in
                MPMediaLibrary.requestAuthorization { newStatus in
                    continuation.resume(returning: newStatus)
                }
            }

            if status == .authorized {
                loadAlbums()
            }
        }
    }

    private func loadAlbums() {
        if let collections = MPMediaQuery.albums().collections {
            self.albums = collections
        }
    }
}
