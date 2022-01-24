//
//  ContactHeaderViewCell.swift
//  ContactsApp
//
//  Created by Sachin Rao on 24/01/22.
//

import UIKit

class ContactHeaderViewCell: UITableViewHeaderFooterView {
  @IBOutlet var header: UILabel!
  override func prepareForReuse() {
    super.prepareForReuse()
    header.text = ""
  }

  func setHeader(title: String) {
    header.text = title
  }
}
