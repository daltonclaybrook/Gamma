import UIKit

public enum Result {
    case match
    case noMatch(original: UIImage, test: UIImage)
    case error(SnapshotError)
}

extension Result {
    public func assertMatch() {
        guard case .match = self else {
            assertionFailure("The snapshot test image does not match the original stored on disk.")
            return
        }
    }
}
