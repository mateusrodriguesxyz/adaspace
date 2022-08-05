//
//  File.swift
//  
//
//  Created by Mateus on 04/08/22.
//

import Vapor

public class Monitor {
    
    var connections = Set<MonitorConnection>()
    
    public init() { }
    
    public func send(_ data: Data) {
        connections.forEach {
            $0.socket.send([UInt8](data))
        }
    }
}
