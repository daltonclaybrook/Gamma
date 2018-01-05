import Foundation

public enum SnapshotError: Error {
    case missingEnvironmentVariable
}

extension SnapshotError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .missingEnvironmentVariable:
            return "You must set the environment variable GAMMA_DIR. More info in README.md"
        }
    }
}
