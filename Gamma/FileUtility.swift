import Foundation
import UIKit

struct FileUtility {
    let basePath: String
    let controlImagesPath: String
    let hashesPlistPath: String
    
    private let fileManager: FileManager
    
    init() throws {
        guard let basePath = ProcessInfo.processInfo.environment["GAMMA_DIR"] else {
            throw SnapshotError.missingEnvironmentVariable
        }
        self.basePath = basePath
        self.controlImagesPath = (basePath as NSString).appendingPathComponent("ControlImages")
        self.hashesPlistPath = (basePath as NSString).appendingPathComponent("hashes.plist")
        self.fileManager = FileManager.default
    }
    
    func checkOrCreateDataDirectory() throws {
        try checkOrCreateDirectory(at: basePath)
        try checkOrCreateDirectory(at: controlImagesPath)
    }
    
    func createOrLoadHashesPlist() throws -> [String: String] {
        if let data = fileManager.contents(atPath: hashesPlistPath) {
            let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
            if let plist = plist as? [String: String] {
                return plist
            } else {
                throw SnapshotError.corruptDataDirectory
            }
        } else {
            let emptyPlist: [String: String] = [:]
            let data = try PropertyListSerialization.data(fromPropertyList: emptyPlist, format: .xml, options: 0)
            fileManager.createFile(atPath: hashesPlistPath, contents: data)
            return emptyPlist
        }
    }
    
    func saveImage(_ image: UIImage, identifier: String, overwrite: Bool) throws {
        guard let data = UIImagePNGRepresentation(image),
            let filename = (identifier as NSString).appendingPathExtension("png") else {
            throw SnapshotError.couldNotSaveImage
        }
        let fullPath = (controlImagesPath as NSString).appendingPathComponent(filename)
        if !overwrite && fileManager.fileExists(atPath: fullPath) {
            return
        }
        let fileURL = URL(fileURLWithPath: fullPath)
        try data.write(to: fileURL, options: .atomic)
    }
    
    func saveHashesPlist(_ plist: [String: String]) throws {
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        let fileURL = URL(fileURLWithPath: hashesPlistPath)
        try data.write(to: fileURL, options: .atomic)
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
}
