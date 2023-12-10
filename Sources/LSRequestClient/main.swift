import LSRequest
import Foundation
/*
 - path
 - query
 - method
 - body
 - paylad

*/

@Queryable
struct LoginQuery {
    @QueryIgnore
    let user: String
    let phone: String
}

@BodyEncodable
struct LoginBody: Encodable {
    let user: String
    let phone: String
}


public struct DataModel: Decodable {
    public struct Lib: Decodable {
        let count: Int
        let list: [String]
    }
    
    let code: Int
    let msg: String
    let data: Lib
}


extension URLSession: Executor {
    public func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try await data(for: request) as! (Data, HTTPURLResponse)
    }
}


@GET("textBase/findAllTittle")
@Payload<DataModel>
struct LoginService {
    
}
