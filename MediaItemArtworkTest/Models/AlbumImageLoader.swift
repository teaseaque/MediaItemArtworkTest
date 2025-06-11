//
//  AlbumImageLoader.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 6/11/25.
//

import Foundation
import MediaPlayer

@MainActor
class AlbumImageLoader: ObservableObject {
    @Published private var images: [MPMediaEntityPersistentID: UIImage] = [:]
    private var loadingTasks: [MPMediaEntityPersistentID: Task<Void, Never>] = [:]

    private var accessOrder: [MPMediaEntityPersistentID] = []
    private var visibleIDs: Set<MPMediaEntityPersistentID> = []

    private let maxCacheSize = 500

    func image(for id: MPMediaEntityPersistentID) -> UIImage? {
        // Update access order when used
        if images[id] != nil {
            moveToMostRecentlyUsed(id)
        }
        return images[id]
    }

    func loadImage(for album: MPMediaItemCollection) {
        let id = album.persistentID
        guard loadingTasks[id] == nil else { return }

        let task = Task {
            defer { self.loadingTasks[id] = nil }

            if let artwork = album.representativeItem?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork,
               let image = artwork.image(at: artwork.bounds.size)?.preparingThumbnail(of: CGSize(width: 65, height: 65)) {
                self.images[id] = image
                self.moveToMostRecentlyUsed(id)
                self.purgeIfNeeded()
            }
        }

        loadingTasks[id] = task
    }

    func markVisible(_ id: MPMediaEntityPersistentID) {
        visibleIDs.insert(id)
    }

    func markInvisible(_ id: MPMediaEntityPersistentID) {
        visibleIDs.remove(id)
    }

    private func moveToMostRecentlyUsed(_ id: MPMediaEntityPersistentID) {
        accessOrder.removeAll { $0 == id }
        accessOrder.append(id)
    }

    private func purgeIfNeeded() {
        while images.count > maxCacheSize {
            if let idToRemove = accessOrder.first(where: { !visibleIDs.contains($0) }) {
                images.removeValue(forKey: idToRemove)
                accessOrder.removeAll { $0 == idToRemove }
            } else {
                // If all are visible, break to avoid removing what’s onscreen
                break
            }
        }
    }
}
