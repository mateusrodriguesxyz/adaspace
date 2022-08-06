import Vapor

func routes(_ app: Application) throws {
    
    app.webSocket("echo") { req, ws in
        // Connected WebSocket.
        print(ws)
    }
    
    app.routes.get { req -> String in
        let routes = req.application.routes.all
        return routes.map(\.description).joined(separator: "\n")
    }
    
    app.routes.get("documentation") { req in
        req.view.render(app.directory.publicDirectory + "documentation/index.html")
    }
    
    try app.register(collection: UserController())
    try app.register(collection: PostController()) 
    try app.register(collection: LikeController())
    try app.register(collection: RemoteConsoleController())
    
}
