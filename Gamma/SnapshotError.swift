import Foundation

public enum SnapshotError: Error {
    case missingEnvironmentVariable
    case couldNotCreateSnapshot
    case corruptDataDirectory
    case underlying(Error)
}

extension SnapshotError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .missingEnvironmentVariable:
            return "You must set the environment variable GAMMA_DIR. More info in README.md"
        case .couldNotCreateSnapshot:
            return "Something went wrong when taking the snapshot."
        case .corruptDataDirectory:
            return "The data directory is corrupt. Try deleting it and running the tests again."
        case .underlying(let error):
            return "underlying error: \(error)"
        }
    }
}
