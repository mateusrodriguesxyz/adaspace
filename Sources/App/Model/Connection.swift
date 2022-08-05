import Vapor

final class MonitorConnection: Hashable {
    
    let id: UUID
    let socket: WebSocket
    
    init(id: UUID = .init(), socket: WebSocket) {
        self.id = id
        self.socket = socket
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MonitorConnection, rhs: MonitorConnection) -> Bool {
        lhs.id == rhs.id
    }
    
}

final class Connection: Hashable {
    
    let id: UUID
    let user: User.Public
    let socket: WebSocket
    
    init(id: UUID = .init(), user: User.Public, socket: WebSocket) {
        self.id = id
        self.user = user
        self.socket = socket
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Connection, rhs: Connection) -> Bool {
        lhs.id == rhs.id
    }
    
}