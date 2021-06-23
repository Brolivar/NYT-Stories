//
//  ArrayViewModel.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 23/6/21.
//

import Foundation

// Protocol that represents a ViewModel that provides data of an a array of a determined type
protocol ArrayViewModel: AnyObject {
    associatedtype ViewModel
    var viewModel: [ViewModel] { get set }
    func count() -> Int
}

extension ArrayViewModel {
    //Default implementation of count() function (can be inherited, and also have its own implementation)
    func count() -> Int {
        return self.viewModel.count
    }
}

extension ArrayViewModel {
    //Global function available to ArrayViewModel types
    // can't have its own implementation in every viewcontroller(since its not defined on the arrayviewmodel)
    func itemAtIndex(_ index: Int) -> ViewModel {
        return self.viewModel[index]
    }
}
