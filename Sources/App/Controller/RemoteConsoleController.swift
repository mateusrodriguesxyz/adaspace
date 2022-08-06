import Vapor

class RemoteConsoleController: RouteCollection {
        
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("console", onUpgrade: onMonitorUpgrade)
    }
    
    func onMonitorUpgrade(request: Request, socket: WebSocket) {
        let connection = RemoteTerminal.Connection(socket: socket)
        RemoteTerminal.default.connections.insert(connection)
    }
    
}
