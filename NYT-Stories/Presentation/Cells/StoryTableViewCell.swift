//
//  StoryTableViewCell.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 22/6/21.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var storyImage: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetToDetault()
        self.storyImage.layer.cornerRadius = 15.0
        self.storyImage.layer.masksToBounds = true
    }

    func configure(from story: StoryProtocol) {
        self.titleLabel.text = story.getStoryTitle()
        self.authorLabel.text = story.getStoryAuthor()
        // Date handling
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"

        // Change to a more readable format
        if let date = dateFormatter.date(from: story.getStoryDate()) {
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
            dateFormatter.string(from: date)
            self.dateLabel.text = dateFormatter.string(from: date)
        } else {
            print("Error formating the date.")
        }

        // Make rounded corners
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }

    func setStoryImage(from image: UIImage) {
        DispatchQueue.main.async {
            self.storyImage.image = image
            self.storyImage.contentMode = .scaleAspectFill
        }
    }

    // Reset the table cells as if it were new
    override func prepareForReuse() {
        self.resetToDetault()
    }

    private func resetToDetault() {
        self.storyImage.image = UIImage()
        self.storyImage.backgroundColor = .lightGray
        self.titleLabel.text = ""
        self.dateLabel.text = ""
    }
}
