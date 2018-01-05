import UIKit

public protocol SnapshotType {
    var snapshotView: UIView { get }
}

public struct Snapshot {
    /// the original image stored on disk. If there is no image on disk, this will contain the test image.
    public let originalImage: UIImage
    public let testImage: UIImage
    public let imagesMatch: Bool
}

extension Snapshot {
    public func assertMatch() {
        assert(imagesMatch, "The snapshot test image does not match the original stored on disk.")
    }
}

extension SnapshotType {
    public func takeSnapshot(identifier: String? = nil) -> Snapshot {
        return Snapshot(originalImage: UIImage(), testImage: UIImage(), imagesMatch: true)
    }
}

extension UIViewController: SnapshotType {
    public var snapshotView: UIView {
        return view
    }
}

extension UIView: SnapshotType {
    public var snapshotView: UIView {
        return self
    }
}
