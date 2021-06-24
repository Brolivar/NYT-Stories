//
//  StoriesRouterTests.swift
//  NYT-StoriesTests
//
//  Created by Jose Bolivar on 24/6/21.
//

import XCTest
import Foundation
@testable import NYT_Stories

class StoriesRouterTests: XCTestCase {

    private var storiesManager: StoriesModelController! = StoriesModelController()
    private var networkManager: NetworkControllerProtocol = NetworkManager()

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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testStoriesAPIReachable() {

        let ex = expectation(description: "Expecting a response from Stories API")

        self.networkManager.downloadStoriesUrls { result in
            switch result {
            case .success(_):
                print("Stories request successfully")
                ex.fulfill()
             case .failure(let error):
                print("Stories request failed: ", error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
                XCTFail("Timeout error: \(error)")
            }
        }
    }


    //Test that the API returns a valid result
    func testStoriesAPI() {

        let ex = expectation(description: "Expecting a success return from the api")

        self.networkManager.downloadStoriesUrls { result in
            switch result {
            case .success(let storiesList):
                print("Stories request successfully")
                if storiesList.isEmpty {
                    print("Return object is nil")
                } else {
                    ex.fulfill()
                }
             case .failure(let error):
                print("Stories request failed: ", error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
                XCTFail("Timeout error: \(error)")
            }
        }
    }

}
