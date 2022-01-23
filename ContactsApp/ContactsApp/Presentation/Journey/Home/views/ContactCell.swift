//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Sachin Rao on 22/01/22.
//

import UIKit

class ContactCell: UITableViewCell {
  @IBOutlet var favoriteMarker: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var thumbnail: UIImageView!

  override func prepareForReuse() {
    super.prepareForReuse()
    thumbnail.image = nil
    favoriteMarker.isHidden = true
  }

  func configure(contactEntity: ContactsEntity) {
    nameLabel.text = contactEntity.fullName
    favoriteMarker.isHidden = !contactEntity.isFavourite
    configureFavoriteIcon()
  }

  private final func configureFavoriteIcon() {
    let image = favoriteMarker?.image?.withRenderingMode(.alwaysTemplate)
    favoriteMarker.image = image
    favoriteMarker.tintColor = favoriteMarker.isHidden ? .clear : .cyan
  }
}
