//
//  ViewController.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 22/6/21.
//

import UIKit

class StoriesListViewController: UIViewController {

    // MARK: - Properties
    //Ideally this should be injected by a third party entity (i.e navigator, segue manager, etc...)
    var storiesManager: StoriesModelController! = StoriesModelController()
    private let refreshControl = UIRefreshControl()
    static let cellHeight = 145
    @IBOutlet private var storiesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.setRefreshControl()
        self.retrieveStoriesList()
    }


    // MARK: Private functions
    private func setRefreshControl() {
        self.refreshControl.tintColor = .gray
        self.refreshControl.addTarget(self, action: #selector(retrieveStoriesList), for: .valueChanged)
        self.storiesTableView.addSubview(refreshControl)
    }

    @objc private func retrieveStoriesList() {
        self.storiesManager.removeStoriesData(completion: {
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
        })

    }

    // MARK: - Navigation
    // A better solution would have been the implementation of coordinators to manage app navigation, ensuring better
    // isolation, abstraction, and better separation of responsabilities
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryDetailsViewController.detailSegueId {
            if let destVc = segue.destination as? StoryDetailsViewController, let selectedIndexPath = self.storiesTableView.indexPathForSelectedRow {
                self.storiesManager.selectedStory(at: selectedIndexPath.row)
                destVc.storyManager = self.storiesManager
                // Change back button title
                let backItem = UIBarButtonItem()
                navigationItem.backBarButtonItem = backItem
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoryTableViewCell.self), for: indexPath) as? StoryTableViewCell
            else { return UITableViewCell() }

        let index = indexPath.row
        if let cellStory = storiesManager.storyAt(index) {
            cell.configure(from: cellStory)
            self.storiesManager.imageAt(index, completion: { image in
                if let storyImage = image {
                    cell.setStoryImage(from: storyImage)
                }
            })
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(StoriesListViewController.cellHeight)
    }
}
