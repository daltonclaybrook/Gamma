import CoreGraphics
import UIKit

struct ImageResult {
    let image: UIImage
    let hash: String
}

struct ImageUtility {
    
    // MARK: Internal
    
    static func generateImageResult(from layer: CALayer) throws -> ImageResult {
        guard let image = snapshotOfLayer(layer),
            let hash = generateHash(from: image) else {
            throw SnapshotError.couldNotCreateSnapshot
        }
        return ImageResult(image: image, hash: hash)
    }
    
    // MARK: Private
    
    private static func snapshotOfLayer(_ layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.layoutIfNeeded()
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private static func generateHash(from image: UIImage) -> String? {
        guard let cgImage = image.cgImage else { return nil }
        guard let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: cgImage.bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        context.draw(cgImage, in: rect)
        guard let data = context.data else { return nil }
        let rgbaData = data.assumingMemoryBound(to: Int8.self)
        let dataLength = UInt32(cgImage.bytesPerRow * cgImage.height)
        return GMACrypto.sha1Hash(ofData: rgbaData, length: dataLength)
    }
}
