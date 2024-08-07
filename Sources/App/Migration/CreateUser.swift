import Fluent

struct CreateUser: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database
            .schema(User.schema)
            .id()
            .field("name", .string)
            .field("avatar", .string)
            .field("username", .string)
            .field("password", .string)
            .unique(on: "username")
            .constraint(.sql(unsafeRaw: "CHECK (LENGTH(name) >= 5)"))
            .constraint(.sql(unsafeRaw: "CHECK (LENGTH(username) >= 5)"))
            .constraint(.sql(unsafeRaw: "CHECK (LENGTH(password) >= 5)"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
    
}
