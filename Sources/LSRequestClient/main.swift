import LSRequest
import Foundation
/*
 - path
 - query
 - method
 - body
 - paylad

*/

//@Queryable
//struct LoginQuery {
//    @QueryIgnore
//    let user: String
//    let phone: String
//}

@BodyEncodable
struct LoginBody: Encodable {
    let phone: String
    let password: String
    let confirm: String = "1"
}



extension LSRequest.Request {
    var domain: String {
        "http://192.168.0.2:9000/"
    }
}


public struct DataModel: Decodable {
    public struct Token: Decodable {
        let token: String
    }
    
    let code: Int
    let msg: String
    let data: Token
}


extension URLSession: Executor {
    public func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try await data(for: request) as! (Data, HTTPURLResponse)
    }
}


@POST("user/login")
@HTTPBody<LoginBody>
@Payload<DataModel>
struct LoginService {
    
}

let token = try await LoginService(request: .init(body: .init(phone: "18178465332", password: "1234"))).request()
print(token)
