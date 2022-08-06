//
//  File.swift
//  
//
//  Created by Mateus on 04/08/22.
//

import Vapor

public class RemoteTerminal: Console {
    
    final class Connection: Hashable {
        
        let id: UUID
        let socket: WebSocket
        
        init(id: UUID = .init(), socket: WebSocket) {
            self.id = id
            self.socket = socket
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: Connection, rhs: Connection) -> Bool {
            lhs.id == rhs.id
        }
        
    }
    
    public static var `default` = RemoteTerminal()
    
    var connections = Set<Connection>()
    
    public init() { }
    
    public func input(isSecure: Bool) -> String {
        fatalError("input(isSecure:) not implemented")
    }
    
    public func output(_ text: ConsoleText, newLine: Bool) {
        Swift.print(#function, self)
        let data = "\(text)".data(using: .utf8)!
        connections.forEach {
            $0.socket.send([UInt8](data))
        }
    }
    
    public func clear(_ type: ConsoleClear) { }
    
    public var size: (width: Int, height: Int) = (0, 0)
    
    public var userInfo: [AnyHashable : Any] = [:]
    
    public func report(error: String, newLine: Bool) {
        
    }
    
    
}
