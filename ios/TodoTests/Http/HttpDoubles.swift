import SwiftUI
@testable import TodoList

class SpyHttp: Http {
    var data_argument_request: URLRequest? = nil
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.data_argument_request = request
        return (Data(), URLResponse())
    }
    
}

class StubHttp: Http {
    var data_returnValue: (Data, URLResponse) = (Data(), URLResponse())
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return data_returnValue
    }
}
