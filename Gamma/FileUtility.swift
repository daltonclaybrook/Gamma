import Foundation
import UIKit

typealias HashesPlist = [String: [String: String]]
extension Dictionary where Key == String, Value == [String: String] {
    func hash(for identifier: String) -> String? {
        return self[Device.model]?[identifier]
    }
    
    mutating func setHash(_ hash: String, for identifier: String) {
        var hashesForDevice = self[Device.model] ?? [:]
        hashesForDevice[identifier] = hash
        self[Device.model] = hashesForDevice
    }
}

struct FileUtility {
    let basePath: String
    let allDevicesPath: String
    let deviceModelPath: String
    let referenceImagesPath: String
    let failureImagesPath: String
    let hashesPlistPath: String
    
    private let fileManager: FileManager
    
    init() throws {
        guard let basePath = ProcessInfo.processInfo.environment["GAMMA_DIR"] else {
            throw SnapshotError.missingEnvironmentVariable
        }
        self.basePath = basePath
        self.allDevicesPath = (basePath as NSString).appendingPathComponent("Devices")
        self.deviceModelPath = (allDevicesPath as NSString).appendingPathComponent(Device.model)
        self.referenceImagesPath = (deviceModelPath as NSString).appendingPathComponent("ReferenceImages")
        self.failureImagesPath = (deviceModelPath as NSString).appendingPathComponent("FailureImages")
        self.hashesPlistPath = (basePath as NSString).appendingPathComponent("hashes.plist")
        self.fileManager = FileManager.default
    }
    
    func checkOrCreateDataDirectory() throws {
        try checkOrCreateDirectory(at: basePath)
        try checkOrCreateDirectory(at: allDevicesPath)
        try checkOrCreateDirectory(at: deviceModelPath)
        try checkOrCreateDirectory(at: referenceImagesPath)
        try checkOrCreateDirectory(at: failureImagesPath)
    }
    
    func createOrLoadHashesPlist() throws -> HashesPlist {
        if let data = fileManager.contents(atPath: hashesPlistPath) {
            let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
            if let plist = plist as? HashesPlist {
                return plist
            } else {
                throw SnapshotError.corruptDataDirectory
            }
        } else {
            let emptyPlist: HashesPlist = [:]
            let data = try PropertyListSerialization.data(fromPropertyList: emptyPlist, format: .xml, options: 0)
            fileManager.createFile(atPath: hashesPlistPath, contents: data)
            return emptyPlist
        }
    }
    
    func loadReferenceImage(withIdentifier identifier: String) -> UIImage? {
        guard let filename = (identifier as NSString).appendingPathExtension("png") else { return nil }
        let fullPath = (referenceImagesPath as NSString).appendingPathComponent(filename)
        return UIImage(contentsOfFile: fullPath)
    }
    
    func saveHashesPlist(_ plist: HashesPlist) throws {
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        let fileURL = URL(fileURLWithPath: hashesPlistPath)
        try data.write(to: fileURL, options: .atomic)
    }
    
    func saveReferenceImage(_ image: UIImage, identifier: String, overwrite: Bool) throws {
        try saveImage(image, identifier: identifier, directoryPath: referenceImagesPath, overwrite: overwrite)
    }
    
    func saveFailureImage(_ image: UIImage, identifier: String, overwrite: Bool) throws {
        try saveImage(image, identifier: identifier, directoryPath: failureImagesPath, overwrite: overwrite)
    }
    
    // MARK: Private
    
    private func checkOrCreateDirectory(at path: String) throws {
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            // directory does not exist. create it.
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false)
        } else if !isDirectory.boolValue {
            // file exists, and it is not a directory as expected
            throw SnapshotError.corruptDataDirectory
        }
    }
    
    private func saveImage(_ image: UIImage, identifier: String, directoryPath: String, overwrite: Bool) throws {
        guard let data = UIImagePNGRepresentation(image),
            let filename = (identifier as NSString).appendingPathExtension("png") else {
                throw SnapshotError.couldNotSaveImage
        }
        let fullPath = (directoryPath as NSString).appendingPathComponent(filename)
        if !overwrite && fileManager.fileExists(atPath: fullPath) {
            return
        }
        let fileURL = URL(fileURLWithPath: fullPath)
        try data.write(to: fileURL, options: .atomic)
    }
}
