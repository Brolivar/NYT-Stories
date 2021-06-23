//
//  StoryDetailsViewController.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 22/6/21.
//

import UIKit
import SafariServices

class StoryDetailsViewController: UIViewController {

    // MARK: - Public properties
    static let detailSegueId = "showDetail"
    //Ideally these should be injected by a third party entity (i.e navigator, segue manager, etc...)
    // Instead of inyecting the whole object, we inyect only the protocol.
    var storyManager: StoriesManagerProtocol?

    @IBOutlet private var storyImage: UIImageView!
    @IBOutlet private var storyTitle: UILabel!
    @IBOutlet private var storyDescription: UITextView!
    @IBOutlet private var authorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedStory = self.storyManager?.getSelectedStory() {
            self.title = selectedStory.getStoryTitle()
            self.storyTitle.text = selectedStory.getStoryTitle()
            self.authorLabel.text = selectedStory.getStoryAuthor()
            self.storyDescription.text = selectedStory.getStoryDescription()
            self.storyManager?.getImage(completion: { [weak self] image in
                DispatchQueue.main.async {
                    self?.storyImage.image = image
                }
            })
            self.storyImage.contentMode = .scaleAspectFill
        }
    }
    @IBAction func seeMoreButtonTapped(_ sender: Any) {
        if let selectedStory = self.storyManager?.getSelectedStory() {
            // As it is preferable to keep the user inside the app, we use SFSafariViewController instead for browsing
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: selectedStory.getStoryUrl(), configuration: config)
            self.present(vc, animated: true)
        }
    }

}
