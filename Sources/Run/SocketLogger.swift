//
//  File.swift
//  
//
//  Created by Mateus on 04/08/22.
//

import Vapor
import App

struct SocketLogger: LogHandler {
    
    public let label: String
    
    var metadata: Logging.Logger.Metadata
    
    var logLevel: Logging.Logger.Level
    
    var monitor: Monitor
    
    public init(label: String, monitor: Monitor, level: Logger.Level = .debug, metadata: Logger.Metadata = [:]) {
        self.label = label
        self.metadata = metadata
        self.logLevel = level
        self.monitor = monitor
    }
    
    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { return self.metadata[key] }
        set { self.metadata[key] = newValue }
    }
    
    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        
        var text: ConsoleText = ""
        
        if self.logLevel <= .trace {
            text += "[ \(self.label) ] ".consoleText()
        }
            
        text += "[ \(level.name) ]".consoleText(level.style)
            + " "
            + message.description.consoleText()

        let allMetadata = (metadata ?? [:]).merging(self.metadata) { (a, _) in a }

        if !allMetadata.isEmpty {
            // only log metadata if not empty
            text += " " + allMetadata.sortedDescriptionWithoutQuotes.consoleText()
        }

        // log file info if we are debug or lower
        if self.logLevel <= .debug {
            // log the concise path + line
            let fileInfo = self.conciseSourcePath(file) + ":" + line.description
            text += " (" + fileInfo.consoleText() + ")"
        }
        
        monitor.send("\(text)".data(using: .utf8)!)
        
    }
    
    private func conciseSourcePath(_ path: String) -> String {
        let separator: Substring = path.contains("Sources") ? "Sources" : "Tests"
        return path.split(separator: "/")
            .split(separator: separator)
            .last?
            .joined(separator: "/") ?? path
    }
    
    
}

private extension Logger.Metadata {
    var sortedDescriptionWithoutQuotes: String {
        let contents = Array(self)
            .sorted(by: { $0.0 < $1.0 })
            .map { "\($0.description): \($1)" }
            .joined(separator: ", ")
        return "[\(contents)]"
    }
}
