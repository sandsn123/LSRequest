import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(LSRequest)
import LSRequest
@testable import LSRequestMacros

let testMacros: [String: Macro.Type] = [
    "Query": QueryableMacro.self,
    "QueryIgnore": QueryableMacro.self,
    "HTTPBody": HTTPBodyMacro.self,
    "GET" : MethodMacro.self,
    "HeaderField" : HeaderFieldMacro.self,
    "URL" : URLMacro.self,
    "URLQuery" : URLQueryMacro.self,
]
#endif

extension Request {
    var domain: String {
        "http://192.168.0.1"
    }
}

final class LSRequestTests: XCTestCase {
    struct LoginBody: Queryable {
        let user: String
        let phone: String
    }

    
    func testMacro() throws {
        #if canImport(LSRequestMacros)
        assertMacroExpansion(
            """
            @GET("user/login")
            @Payload<DataModel>
            @URLQuery<LoginQuery>
            struct LoginService {
                
            }
            """,
            expandedSource: """
            struct LoginBody {
                let user: String
                let phone: String
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    

    func testMacroWithStringLiteral() throws {
        var domain: String {
            "http://192.168.0.3"
        }
        #if canImport(LSRequestMacros)
        assertMacroExpansion(
            """
            
            #URL("user/login", "\(domain)")
            """,
            expandedSource: #"""
            URL("Hello", url)!
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
