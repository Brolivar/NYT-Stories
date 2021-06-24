//
//  NYT_StoriesTests.swift
//  NYT-StoriesTests
//
//  Created by Jose Bolivar on 24/6/21.
//

import XCTest
@testable import NYT_Stories


class NYT_StoriesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    // Test that the Codable parser is able to decode the json format into a Story object
     func testStoryCodable() {

        // properties to match
        let storyID = "nyt://article/dc98d490-3a44-5a13-a402-ed7d9a0937a0"
        let storyTitle = "Staving Off G.O.P. Attacks, Democrats Show New Urgency on Crime"
        let storyDescription = "A strong showing by Eric Adams in the New York mayoral race and President Biden’s announcement of a new crime-fighting agenda signal a shift by Democrats toward themes of public safety."
        let storyAuthor = "By Alexander Burns"
        let storyURL = URL(string: "https://www.nytimes.com/2021/06/23/us/politics/gop-democrats-defund-police-biden.html")
        let publishedDate = "2021-06-23T18:47:24-04:00"
        let mediaURL =  URL(string: "https://static01.nyt.com/images/2021/06/23/us/politics/23dems-crime1/merlin_189697710_9e3c4d60-14ff-431e-b786-b8de0fb89ad0-superJumbo.jpg")


        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Story", withExtension: "json") else {
            XCTFail("Missing File: Story.json")
            return
        }

        do {
            let responseData = try Data(contentsOf: url)
            let story = try JSONDecoder().decode(APIStoriesResponse.self, from: responseData)

            if let storyResult = story.results?.first {
                //Check once parsed, individual properties match
                XCTAssertEqual(storyResult.getStoryID(), storyID)
                XCTAssertEqual(storyResult.getStoryTitle(), storyTitle)
                XCTAssertEqual(storyResult.getStoryDescription(), storyDescription)
                XCTAssertEqual(storyResult.getStoryAuthor(), storyAuthor)
                XCTAssertEqual(storyResult.getStoryDate(), publishedDate)
                XCTAssertEqual(storyResult.getStoryUrl(), storyURL)

                if let firstMedia = storyResult.getStoryMedia()?.first {
                    XCTAssertEqual(firstMedia.getImageURL(), mediaURL)
                } else {
                    XCTFail("\nError decoding media")
                }
            } else {
                XCTFail("\nError decoding results")
            }
        } catch {
            XCTFail("\nError decoding Story json into object: \(error)\n")
        }
     }
}
