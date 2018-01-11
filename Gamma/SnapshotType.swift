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
        do {
            return try throwingTakeSnapshot(identifier: identifier)
        } catch let error {
            return Result(error: error)
        }
    }
    
    // MARK: Private
    
    private func throwingTakeSnapshot(identifier: String?) throws -> Result {
        let fileUtility = try FileUtility()
        try fileUtility.checkOrCreateDataDirectory()
        var hashes = try fileUtility.createOrLoadHashesPlist()
        
        let fullIdentifier = createFullIdentifier(withSuffix: identifier)
        let imageResult = try ImageUtility.generateImageResult(from: snapshotView)
        
        if let existingHash = hashes[fullIdentifier] {
            if imageResult.hash == existingHash {
                // test passes. save the image to originals folder if none exists.
                try fileUtility.saveImage(imageResult.image, identifier: fullIdentifier, overwrite: false)
            } else {
                // test fails. save the composite image to the failure directory if an original exists.
                // TODO
                return .noMatch(original: nil, test: imageResult.image)
            }
        } else {
            // no image hash exists, so the test technically passes. save the image to the originals folder, overwriting if necessary.
            hashes[fullIdentifier] = imageResult.hash
            try fileUtility.saveImage(imageResult.image, identifier: fullIdentifier, overwrite: true)
            try fileUtility.saveHashesPlist(hashes)
        }
        
        return .match
    }
    
    private func createFullIdentifier(withSuffix suffix: String?) -> String {
        let model = Device.model()
        let typeName = "\(type(of: self))"
        let suffix = suffix ?? "Default"
        return "\(model)-\(typeName)-\(suffix)"
    }
}
