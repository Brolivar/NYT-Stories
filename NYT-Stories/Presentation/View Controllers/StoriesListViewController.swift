//
//  ViewController.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 22/6/21.
//

import UIKit

class StoriesListViewController: UIViewController {

    // MARK: - Public Variables
    //Ideally this should be injected by a third party entity (i.e navigator, segue manager, etc...)
    var storiesManager: StoriesModelController! = StoriesModelController()
    private let refreshControl = UIRefreshControl()
    @IBOutlet private var storiesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.retrieveStoriesList()
    }

    @objc private func retrieveStoriesList() {
//        self.storiesManager.removeStoriesData()    //  TODO: Manage reset of data when coming from refresh control
        print("Fetching stories...")
        self.refreshControl.beginRefreshing()
        self.storiesManager.requestStories { [weak self] status in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.storiesTableView.reloadData()
            }
            if status {
                print("Stories loaded sucessfully")
            } else {
                print("Error retrieving stories")
            }
        }
    }
}

// MARK: - UITableViewDelegate Extension
extension StoriesListViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource Extension
extension StoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storiesManager.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
