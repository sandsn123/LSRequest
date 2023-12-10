- path
- query
- method
- body
- paylad


@GET("user/login")
struct Login {
    @Query
    struct Body {
        let name: String
        let psw: String
    }
}

let body = .init(name: "sia", psw: "123")
let token = try await LoginService().send(_ body: body)
