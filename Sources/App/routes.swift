import Vapor

func routes(_ app: Application, monitor: Monitor) throws {
    
    app.routes.get { req -> String in
        let routes = req.application.routes.all
        return routes.map(\.description).joined(separator: "\n")
    }
    
    app.routes.get("documentation") { req in
        req.view.render(app.directory.publicDirectory + "documentation/index.html")
    }
    
    try app.register(collection: UserController())
    try app.register(collection: PostController())
    try app.register(collection: SocketController(monitor: monitor))
    try app.register(collection: LikeController())
    
}
