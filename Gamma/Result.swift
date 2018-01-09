import UIKit
import XCTest

public enum Result {
    case match
    case noMatch(original: UIImage?, test: UIImage)
    case error(SnapshotError)
}

extension Result {
    init(error: Error) {
        let snapshotError = (error as? SnapshotError) ?? .underlying(error)
        self = .error(snapshotError)
    }
    
    public func assertMatch() {
        switch self {
        case .match:
            break
        case .noMatch:
            XCTFail("The snapshot test image does not match the original stored on disk.")
        case .error(let error):
            XCTFail(error.description)
        }
    }
}
