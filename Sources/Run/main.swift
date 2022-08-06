import App
import Vapor

var env = try Environment.detect()

try LoggingSystem.bootstrap(from: &env) { level in
    let console = Terminal()
    return { (label: String) in
        MultiplexLogHandler([
            ConsoleLogger(label: label, console: console, level: level),
            ConsoleLogger(label: label, console: RemoteTerminal.default, level: level)
        ])
    }
}

let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
