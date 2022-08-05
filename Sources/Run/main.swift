import App
import Vapor

var monitor = Monitor()
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env) { level in
    let console = Terminal()
    return { (label: String) in
        MultiplexLogHandler([
            SocketLogger(label: label, monitor: monitor),
            ConsoleLogger(label: label, console: console, level: level)
        ])
    }
}
let app = Application(env)
defer { app.shutdown() }
try configure(app, monitor: monitor)
try app.run()
