import Foundation

public struct GammaSettings {
    public private(set) static var current: GammaSettings = .default()
    
    public let forceRecord: Bool
    
    public init(forceRecord: Bool) {
        self.forceRecord = forceRecord
    }
}

extension GammaSettings {
    public static func `default`() -> GammaSettings {
        return GammaSettings(
            forceRecord: false
        )
    }
    
    public func makeCurrent() {
        GammaSettings.current = self
    }
}
