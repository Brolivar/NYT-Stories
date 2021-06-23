//
//  Story.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 22/6/21.
//

import Foundation

protocol StoryProtocol {
    func getStoryID() -> String
    func getStoryTitle() -> String
    func getStoryDescription() -> String
    func getStoryMedia() -> [StoryMedia]?
    func getStoryDate() -> String
    func getStoryUrl() -> URL
    func getStoryAuthor() -> String
}

protocol MediaProtocol {
    func getImageURL() -> URL
}

// By abstracting the story into a protocol we ensure the whole object is not shared,
// only the protocol with the functions to read or write, which is way safer.
struct Story: Decodable {
    private var storyID: String
    private var storyTitle: String
    private var storyDescription: String
    private var storyMedia: [StoryMedia]?
    private var storyAuthor: String
    private var storyURL: URL
    private var publishedDate: String

    enum CodingKeys: String, CodingKey {
        case storyID = "uri"
        case storyTitle = "title"
        case storyDescription = "abstract"
        case storyMedia = "multimedia"
        case storyAuthor = "byline"
        case storyURL = "url"
        case publishedDate = "published_date"
    }

}

struct StoryMedia: Decodable {
    private var mediaUrl: URL
    enum CodingKeys: String, CodingKey {
        case mediaUrl = "url"
    }
}
// MARK: - StoryProtocol Extension
extension Story: StoryProtocol {
    func getStoryID() -> String {
        return storyID
    }
    func getStoryTitle() -> String {
        return storyTitle
    }
    func getStoryDescription() -> String {
        return storyDescription
    }
    func getStoryMedia() -> [StoryMedia]? {
        return storyMedia
    }
    func getStoryDate() -> String {
        return publishedDate
    }
    func getStoryUrl() -> URL {
        return storyURL
    }
    func getStoryAuthor() -> String {
        return storyAuthor
    }
}

// MARK: - MediaProtocol Extension
extension StoryMedia: MediaProtocol {
    func getImageURL() -> URL {
        return mediaUrl
    }
}
