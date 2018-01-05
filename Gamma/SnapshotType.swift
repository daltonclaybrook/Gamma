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
        
        let model = deviceModel()
        return .match
    }
    
    // MARK: Private
    
    private func deviceModel() -> String? {
        if let simulatorModel = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModel
        }
        
        var size: size_t = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
    
    private func dataFilePath() -> String? {
        return ProcessInfo.processInfo.environment["GAMMA_DIR"]
    }
}
