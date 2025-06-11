//
//  AlbumGridRepresentable.swift
//  MediaItemArtworkTest
//
//  Created by Tom Kane on 6/10/25.
//

import SwiftUI
import MediaPlayer

struct AlbumGridRepresentable: UIViewControllerRepresentable {
    let albums: [MPMediaItemCollection]

    func makeUIViewController(context: Context) -> UIViewController {
        return AlbumGridViewController(albums: albums)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No dynamic updates needed for now
    }
}

class AlbumGridViewController: UICollectionViewController {

    let albums: [MPMediaItemCollection]

    init(albums: [MPMediaItemCollection]) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let side = (UIScreen.main.bounds.width - 40) / 5  // Adaptive ~65pt
        layout.itemSize = CGSize(width: side, height: side)

        self.albums = albums
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ValForProp"
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = albums[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdentifier, for: indexPath) as! AlbumCell

        if let artwork = album.representativeItem?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork,
           let image = artwork.image(at: artwork.bounds.size) {
            print("2-", album.representativeItem?.albumTitle ?? "", ":", CFGetRetainCount(artwork), CFGetRetainCount(image))
            cell.setImage(image)
        } else {
            cell.setImage(nil)
        }

        return cell
    }
}

class AlbumCell: UICollectionViewCell {
    static let reuseIdentifier = "AlbumCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
        imageView.backgroundColor = image == nil ? .gray : .clear
    }
}
