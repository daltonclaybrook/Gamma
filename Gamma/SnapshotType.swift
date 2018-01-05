import UIKit

public protocol SnapshotType {
    var snapshotView: UIView { get }
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

extension SnapshotType {
    public func takeSnapshot(identifier: String? = nil) -> Result {
        guard let dataPath = dataFilePath() else {
            return .error(SnapshotError.missingEnvironmentVariable)
        }
        
        return .match
    }
    
    // MARK: Private
    
    func dataFilePath() -> String? {
        return ProcessInfo.processInfo.environment["GAMMA_DIR"]
    }
}
