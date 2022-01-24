//
//  HomeViewController.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import UIKit

class HomeViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  var homeViewModel: HomeViewModelType?
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUi()
    showHUD(progressLabel: "Loading...")
    homeViewModel?.fetchContact()
  }

  private final func setupUi() {
    configureTableView()
  }

  private final func configureTableView() {
    tableView.backgroundColor = .clear
    tableView.register(UINib(nibName: "ContactCell", bundle: nil),
                       forCellReuseIdentifier: "ContactCell")
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 72
    tableView.dataSource = self
    tableView.delegate = self
    tableView.sectionIndexBackgroundColor = .clear
    tableView.sectionIndexColor = .cyan
    tableView.tableFooterView = UIView()
  }
}

extension HomeViewController: HomeViewModelToControllerDelegate {
  func refreshTable(at index: IndexPath) {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadRows(at: [index], with: .automatic)
    }
  }

  func showErrorMessage(message: String) {}

  func refreshTable() {
    dismissHUD()
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
    }
  }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    homeViewModel?.numberOfRowsInSection(section: section) ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
    if let cell = cell as? ContactCell, let model = homeViewModel, let entity = model.getItem(at: indexPath) {
      cell.configure(contactEntity: entity)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    .none
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let label = homeViewModel?.getFavoriteTitle(at: indexPath) ?? "Favorite"
    let action = UIContextualAction(style: .normal, title: label) { [weak self] _, _, completionHandler in
      self?.handleMarkAsFavourite(at: indexPath)
      completionHandler(true)
    }
    action.backgroundColor = .systemBlue
    let config = UISwipeActionsConfiguration(actions: [action])
    config.performsFirstActionWithFullSwipe = true
    return config
  }

  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at _: Int) -> Int {
    guard let i = homeViewModel?.getIndex(for: title) else { return 0 }
    let indexPath = IndexPath(row: i, section: 0)
    tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    return 1
  }

  func sectionIndexTitles(for _: UITableView) -> [String]? {
    homeViewModel?.getIndexTitles()
  }

  private func handleMarkAsFavourite(at index: IndexPath) {
    homeViewModel?.toggleItemFavorite(at: index)
  }
}
