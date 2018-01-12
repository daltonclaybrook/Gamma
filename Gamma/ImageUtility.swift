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
    
    static func createDiff(between image1: UIImage, and image2: UIImage) throws -> UIImage {
        let size = CGSize(
            width: max(image1.size.width, image2.size.width),
            height: max(image1.size.height, image2.size.height)
        )
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            throw SnapshotError.couldNotCreateDiff
        }
        
        let image1Rect = CGRect(origin: .zero, size: image1.size)
        image1.draw(in: image1Rect)
        context.setAlpha(0.5)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        image2.draw(in: CGRect(origin: .zero, size: image2.size))
        context.setBlendMode(.difference)
        context.setFillColor(UIColor.white.cgColor)
        context.fill(image1Rect)
        context.endTransparencyLayer()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            return image
        } else {
            throw SnapshotError.couldNotCreateDiff
        }
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
    
    private static func createCGContext(for image: CGImage) -> CGContext? {
        return CGContext(
            data: nil,
            width: image.width,
            height: image.height,
            bitsPerComponent: image.bitsPerComponent,
            bytesPerRow: image.bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )
    }
    
    private static func generateHash(from image: UIImage) -> String? {
        guard let cgImage = image.cgImage,
            let context = createCGContext(for: cgImage) else { return nil }
        
        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        context.draw(cgImage, in: rect)
        guard let data = context.data else { return nil }
        let rgbaData = data.assumingMemoryBound(to: Int8.self)
        let dataLength = UInt32(cgImage.bytesPerRow * cgImage.height)
        return GMACrypto.sha1Hash(ofData: rgbaData, length: dataLength)
    }
}
