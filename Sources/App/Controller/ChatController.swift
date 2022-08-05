import Vapor

class SocketController: RouteCollection {
    
    let monitor: Monitor
    
    private var connections = Set<Connection>()
    
    public init(monitor: Monitor, connections: Set<Connection> = Set<Connection>()) {
        self.monitor = monitor
        self.connections = connections
    }
    
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("monitor", onUpgrade: onMonitorUpgrade)
        routes.group(Token.authenticator()) {
            $0.webSocket("chat", onUpgrade: onUpgrade)
        }
    }
    
    func onMonitorUpgrade(request: Request, socket: WebSocket) {
        let connection = MonitorConnection(socket: socket)
        monitor.connections.insert(connection)
        socket.onText { (ws, text) in
            do {
                print(text)
                try self.dispatch(text, from: connection)
            } catch {
                print(error)
            }
        }
    }
    
    func onUpgrade(request: Request, socket: WebSocket) {
        do {
            let user = try request.auth.require(User.self)
            let connection = Connection(user: user.public, socket: socket)
            connections.insert(connection)
            socket.onText { (ws, text) in
                do {
                    try self.dispatch(text, from: connection)
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
            socket.close(promise: nil)
        }
    }
    
    func dispatch(_ text: String, from connection: MonitorConnection) throws {
//        let message = Message(user: connection.user, text: text)
        let data = text.data(using: .utf8)!
        monitor.connections.forEach {
            $0.socket.send([UInt8](data))
        }
    }
    
    func dispatch(_ text: String, from connection: Connection) throws {
        let message = Message(user: connection.user, text: text)
        let data = try JSONEncoder().encode(message)
        connections.forEach {
            $0.socket.send([UInt8](data))
        }
    }
    
}
