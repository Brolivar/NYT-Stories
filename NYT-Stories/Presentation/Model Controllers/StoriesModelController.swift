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
    func storyAt(_ index: Int) -> StoryProtocol
//    func imageAt(_ index: Int, completion: @escaping (UIImage?) -> Void)
    func selectedStory(at index: Int)
//    func removeStoriesData()
}

protocol StoriesManagerProtocol: AnyObject {
//    func getSelectedStory() -> StoryProtocol?
//    func getImage(completion: @escaping (UIImage?) -> Void)
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

    func storyAt(_ index: Int) -> StoryProtocol {
        return self.itemAtIndex(index)
    }

    func selectedStory(at index: Int) {
        self.selectedStory = index
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
}
