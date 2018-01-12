import UIKit

public protocol SnapshotType {
    var snapshotLayer: CALayer { get }
    func prepareForSnapshot()
}

extension SnapshotType {
    public func prepareForSnapshot() {
        // no-op
    }
}

extension UIViewController: SnapshotType {
    public var snapshotLayer: CALayer {
        return view.layer
    }
    
    public func prepareForSnapshot() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = self
    }
}

extension UIView: SnapshotType {
    public var snapshotLayer: CALayer {
        return layer
    }
}

extension CALayer: SnapshotType {
    public var snapshotLayer: CALayer {
        return self
    }
}

extension SnapshotType {
    public func takeSnapshot(identifier: String? = nil, function: StaticString = #function) -> Result {
        do {
            return try throwingTakeSnapshot(identifier: identifier, function: function)
        } catch let error {
            return Result(error: error)
        }
    }
    
    // MARK: Private
    
    private func throwingTakeSnapshot(identifier: String?, function: StaticString) throws -> Result {
        let settings = GammaSettings.current
        let fileUtility = try FileUtility()
        try fileUtility.checkOrCreateDataDirectory()
        var hashes = try fileUtility.createOrLoadHashesPlist()
        let fullId = createFullIdentifier(withFunction: function, identifier: identifier)
        
        self.prepareForSnapshot()
        let imageResult = try ImageUtility.generateImageResult(from: snapshotLayer)
        
        if !settings.forceRecord, let existingHash = hashes.hash(for: fullId) {
            if imageResult.hash == existingHash {
                // test passes. save the image to originals folder if none exists.
                try fileUtility.saveImage(imageResult.image, identifier: fullId, overwrite: false)
            } else {
                // test fails. save the composite image to the failure directory if an original exists.
                // TODO
                return .noMatch(original: nil, test: imageResult.image)
            }
        } else {
            // no image hash exists, so the test technically passes. save the image to the originals folder, overwriting if necessary.
            hashes.setHash(imageResult.hash, for: fullId)
            try fileUtility.saveImage(imageResult.image, identifier: fullId, overwrite: true)
            try fileUtility.saveHashesPlist(hashes)
        }
        
        return .match
    }
    
    private func createFullIdentifier(withFunction function: StaticString, identifier: String?) -> String {
        var fullId = function
            .description
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
        if let identifier = identifier {
            fullId.append("-\(identifier)")
        }
        return fullId
    }
}
