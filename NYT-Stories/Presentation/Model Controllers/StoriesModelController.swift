//
//  StoriesModelController.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 22/6/21.
//

import UIKit

protocol StoriesControllerProtocol: AnyObject {
    func requestStories(completion: @escaping (Bool) -> Void)
    func count() -> Int
    func storyAt(_ index: Int) -> StoryProtocol?
    func imageAt(_ index: Int, completion: @escaping (UIImage?) -> Void)
    func selectedStory(at index: Int)
    func storyMediaAt(_ index: Int) -> StoryMedia?
    func removeStoriesData(completion: () -> Void)
}

protocol StoriesManagerProtocol: AnyObject {
    func getSelectedStory() -> StoryProtocol?
    func getImage(completion: @escaping (UIImage?) -> Void)
}

// Ideally we would have 2 separates Model Controllers - one for the storiesList array, another one for each Story item that would be injected to "StoryDetailsVc", but due to the low complexity of the project, and time constraints we're only implementing one
class StoriesModelController: ArrayViewModel {

    // MARK: - Properties
    typealias ViewModel = StoryProtocol
    var viewModel: [StoryProtocol] = [] //This should be private but Swift doesn't allow private vars in protocols - Privacy is accomplished by injecting an abstraction
    // 'StoriesControllerProtocol' rather of a type 'StoriesModelController'

    // We use this dictionary as a simple and cheap 'cache' method to keep already downloaded images in memory.
    // There are more effective ways of achieving this, be it by caching it (easily by third-party libraries) or memory (f.e UserDefaults), not implemented by time constraints
    //
    private var storyImages: [String: UIImage] = [:]
    private var networkManager: NetworkControllerProtocol = NetworkManager()

    private var selectedStory: Int?
}

// MARK: - StoriesControllerProtocol extension
extension StoriesModelController: StoriesControllerProtocol {

    func storyAt(_ index: Int) -> StoryProtocol? {
        if index >= 0 && index < self.viewModel.count {     // Avoid out of index errors.
            return self.itemAtIndex(index)
        } else {
            return .none
        }
    }

    func selectedStory(at index: Int) {
        self.selectedStory = index
    }

    // Note: We only retrieve the first image for this project's purpose
    // but we could actually return the whole array, and display them on the detailView
    func storyMediaAt(_ index: Int) -> StoryMedia? {
        if let storyMedia = self.viewModel[index].getStoryMedia() {
            return storyMedia.first
        } else {
            return .none
        }
    }

    func requestStories(completion: @escaping (Bool) -> Void) {

        self.networkManager.downloadStoriesUrls { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let storiesList):
                print("Stories request successfully")
//                print("Stories List: ", storiesList)
                for newStory in storiesList {
                    self.viewModel.append(newStory)
                }
                completion(true)
             case .failure(let error):
                print("Stories request failed: ", error)
                completion(false)
            }
        }
    }


    // Download image, and it to the dictionary
    private func downloadImage(storyID: String, imageUrl: URL, completion: @escaping (UIImage?) -> Void) {
        self.networkManager.downloadImage(from: imageUrl, completion: { [weak self] imageData in
            let storyImage = UIImage(data: imageData)
            self?.storyImages[storyID] = storyImage
            completion(storyImage)
        })
    }

    func imageAt(_ index: Int, completion: @escaping (UIImage?) -> Void) {

        if index >= 0 && index < self.viewModel.count {
            // We avoid redownloading
            let storyID = self.viewModel[index].getStoryID()
            if let image = self.storyImages[storyID] {
                completion(image)
            } else {
                if let imageUrl = self.storyMediaAt(index)?.getImageURL() {
                    self.downloadImage(storyID: storyID, imageUrl: imageUrl) { pugImage in
                        completion(pugImage)
                    }
                } else {
                    completion(.none)
                }
            }
        }
    }
    // Remove Story data - used for refresh control
    func removeStoriesData(completion: () -> Void) {
        self.viewModel.removeAll()
        self.storyImages.removeAll()
        self.selectedStory = .none
        completion()
    }
}

extension StoriesModelController: StoriesManagerProtocol {
    func getSelectedStory() -> StoryProtocol? {
        if let index = self.selectedStory {
            return self.viewModel[index]
        } else {
            return .none
        }
    }

    func getImage(completion: @escaping (UIImage?) -> Void) {
        if let index = self.selectedStory {
            let storyID = self.viewModel[index].getStoryID()
            if let image = self.storyImages[storyID] {     // Image is already downloaded
                completion(image)
            } else {
                if let imageURL = self.storyMediaAt(index)?.getImageURL() {
                    self.downloadImage(storyID: storyID, imageUrl: imageURL) { image in
                        completion(image)
                    }
                } else {
                    completion(.none)
                }
            }
        }
    }

}
