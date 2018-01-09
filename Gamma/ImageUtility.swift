import UIKit

struct ImageResult {
    let image: UIImage
    let hash: String
}

struct ImageUtility {
    
    // MARK: Internal
    
    static func generateImageResult(from view: UIView) throws -> ImageResult {
        let image = snapshotOfView(view)
        guard let hash = generateHash(from: image) else {
            throw SnapshotError.couldNotCreateSnapshot
        }
        return ImageResult(image: image, hash: hash)
    }
    
    // MARK: Private
    
    private static func snapshotOfView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private static func generateHash(from image: UIImage) -> String? {
        guard let cgImage = image.cgImage else { return nil }
        let bitsPerComponent = 8
        let bytesPerRow = cgImage.width * 4
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo
        ) else {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        context.draw(cgImage, in: rect)
        guard let data = context.data else { return nil }
        let rgbaData = data.assumingMemoryBound(to: Int8.self)
        let dataLength = UInt32(bytesPerRow * cgImage.height)
        return GMACrypto.sha256Hash(ofData: rgbaData, length: dataLength)
    }
}