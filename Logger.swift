import Foundation

/// A message logger for recording messages with different severity
public protocol MessageLogger {
    func verboseMessage(_ item: Any)
    func debugMessage(_ item: Any)
    func infoMessage(_ item: Any)
    func warningMessage(_ item: Any)
    func errorMessage(_ item: Any)
}

public struct LoggingLevel: OptionSet, Comparable {
    public static let verbose = LoggingLevel(rawValue: 0)
    public static let debug = LoggingLevel(rawValue: 1)
    public static let info = LoggingLevel(rawValue: 2)
    public static let warning = LoggingLevel(rawValue: 4)
    public static let error = LoggingLevel(rawValue: 8)
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

// make LoggingLevel conform to Comparable
public func < (lhs: LoggingLevel, rhs: LoggingLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

/// A convenience struct for accessing defualt logging class.
public struct Logger {
    public static var loggingLevel = LoggingLevel.verbose
    
    public static let logger: MessageLogger = EmojiLogger()
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    
    public static func verbose(_ items: Any?..., file: String = #file, function: String = #function, line: Int = #line) {
        guard loggingLevel <= .verbose else { return }
        guard let url = URL(string: file) else { return }
        let fileName = url.deletingPathExtension().lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        logger.verboseMessage("\(timestamp) \(fileName).\(function):\(line) - \(stringify(items))")
    }
    
    public static func debug(_ items: Any?...) {
        guard loggingLevel <= .debug else { return }
        logger.debugMessage(stringify(items))
    }
    
    public static func info(_ items: Any?...) {
        guard loggingLevel <= .info else { return }
        logger.infoMessage(stringify(items))
    }
    
    public static func warn(_ items: Any?...) {
        guard loggingLevel <= .warning else { return }
        logger.warningMessage(stringify(items))
    }
    
    public static func error(_ items: Any?...) {
        guard loggingLevel <= .error else { return }
        logger.errorMessage(stringify(items))
    }
    
    private static func stringify(_ items: [Any?], withSeparator separator: String = " ") -> String {
        return items.map { type(of: ($0 ?? "") as Any) is AnyClass ? "\(type(of: $0!))" : String(describing: $0 ?? "nil") }
            .joined(separator: separator)
    }
}

/// An Emoji-based logger
open class EmojiLogger: MessageLogger {
    
    public init() {}
    
    public func verboseMessage(_ item: Any) {
        print("⚙️ \(item)")
    }
    
    public func debugMessage(_ item: Any) {
        print("💬 \(item)")
    }
    
    public func infoMessage(_ item: Any) {
        print("ℹ️ \(item)")
    }
    
    public func warningMessage(_ item: Any) {
        print("⚠️ \(item)")
    }
    
    public func errorMessage(_ item: Any) {
        print("🚫 \(item)")
    }
}

/// A plain text message logging class
public class PlainLogger: MessageLogger {
    
    public init() {}
    
    public func verboseMessage(_ item: Any) {
        print("[VERBOSE] \(item)")
    }
    
    public func debugMessage(_ item: Any) {
        print("[DEBUG] \(item)")
    }
    
    public func infoMessage(_ item: Any) {
        print("[INFO] \(item)")
    }
    
    public func warningMessage(_ item: Any) {
        print("[WARNING] \(item)")
    }
    
    public func errorMessage(_ item: Any) {
        print("[ERROR] \(item)")
    }
}
