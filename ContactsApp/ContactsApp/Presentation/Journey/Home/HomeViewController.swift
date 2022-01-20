//
//  HomeViewController.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import UIKit

class HomeViewController: UIViewController {
  var homeViewModelType: HomeViewModelType?
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
}

extension HomeViewController: HomeViewModelToControllerDelegate {}
