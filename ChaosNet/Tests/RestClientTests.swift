//
//  RestClientTests.swift
//  Pods
//
//  Created by Fu Lam Diep on 30.12.21.
//

import XCTest
@testable import ChaosNet

public class RestClientTests: XCTestCase {

    let baseURL: URL = URL(string: "https://test.com/api")!

    let restTransportEngine = MockRestTransportEngine()

    let restClientDelegate = MockRestClientDelegate()

    lazy var restClient: RestClient = RestClient(transportEngine: restTransportEngine)

    var user: User!

    var userData: Data!

    public override func setUp() {
        restTransportEngine.reset()
        guard let bundlePath = Bundle(for: RestClientTests.self).path(forResource: "Chaos_ChaosNetTests", ofType: "bundle"),
              let dataURL = Bundle(path: bundlePath)?.url(forResource: "User", withExtension: "json") else {
            fatalError()
        }

        restClient.maxRescueCount = 1
        restClient.delegate = restClientDelegate

        do {
            let data = try Data(contentsOf: dataURL)
            user = try JSONDecoder().decode(User.self, from: data)
            userData = try JSONEncoder().encode(User(username: "John Doe", email: "john.doe@chaosarts.de"))
        } catch {
            fatalError(error.localizedDescription)
        }
    }


    // MARK: - Common Request Tests

    public func testExecute_sendsURLRequest () async {
        // Assign
        let requests = [
            restClient.makeRequest(at: "user/data")
                .setQueryParameter("query1", value: "value")
                .setQueryParameter("query2", value: nil)
                .setHeader("header1", value: "headerValue")
                .setPayload("".data(using: .utf8)),
            restClient.makeRequest(at: "https://net.chaos.de/user/data")
        ]

        // Act

        for request in requests {
            _ = try? await restClient.response(forRequest: request, relativeTo: URL(string: "https://net.chaosarts.de"))
        }

        // Assert
        XCTAssertEqual(restTransportEngine.requests.count, requests.count)

        XCTAssertEqual(restTransportEngine.requests[0].url?.host, "net.chaosarts.de")
        XCTAssertEqual(restTransportEngine.requests[0].url?.scheme, "https")
        XCTAssertEqual(restTransportEngine.requests[0].url?.path, "/user/data")
        XCTAssertEqual(restTransportEngine.requests[0].allHTTPHeaderFields?.count, 1)
        XCTAssertEqual(restTransportEngine.requests[0].url?.components(resolvingAgainstBaseURL: false)?.queryItems?.count, 2)
        XCTAssertNotNil(restTransportEngine.requests[0].httpBody)

        XCTAssertEqual(restTransportEngine.requests[1].url?.host, "net.chaos.de")
        XCTAssertEqual(restTransportEngine.requests[1].url?.scheme, "https")
        XCTAssertEqual(restTransportEngine.requests[1].url?.path, "/user/data")
        XCTAssertEqual(restTransportEngine.requests[1].allHTTPHeaderFields?.count, 0)
        XCTAssertEqual(restTransportEngine.requests[1].url?.components(resolvingAgainstBaseURL: false)?.queryItems, nil)
        XCTAssertEqual(restTransportEngine.requests[1].httpBody, nil)
    }

    public func testExecute_returnsError_whenRestRequestIsInvalid () async {
        // Assign
        let request = restClient.makeRequest(at: "hps://fulam@chrono24:bam")

        // Act
        var catchedError: URLError?
        do {
            _ = try await restClient.response(forRequest: request, relativeTo: nil)
        } catch let error as RestInternalError {
            catchedError = error.previous as? URLError
        } catch {

        }

        XCTAssertNotNil(catchedError)
        XCTAssertEqual(catchedError?.code, .badURL)
    }

    public func testExecute_returnsError_whenSendingRequestFails () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        let transportEngineError = URLError(.notConnectedToInternet)
        restTransportEngine.results = [.failure(transportEngineError)]

        // Act
        var restClientError: RestInternalError?
        do {
            _ = try await restClient.response(forRequest: request, relativeTo: nil)
        } catch let error as RestInternalError {
            restClientError = error
        } catch {

        }

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 3)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isPerformPreRequestFor, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isSendingRequestDidFailWithError, true)
        XCTAssertEqual(restClientError?.code, .engine)
        XCTAssertEqual(restClientError?.previous as? URLError, transportEngineError)
    }

    public func testExecute_returnsError_whenDelegateNotRescuingNonSuccessResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restTransportEngine.results = [unauthorizedResponseResult(for: baseURL)]

        restClientDelegate.acceptsResponse = { _, _ in false }

        // Act
        var catchedError: Error?
        do {
            _ = try await restClient.response(forRequest: request, relativeTo: nil)
        } catch {
            catchedError = error
        }

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 5)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isPerformPreRequestFor, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isDidSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 3]?.isAcceptsResponse, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 4]?.isShouldRescueRequest, true)
        XCTAssertNotNil(catchedError)
    }

    public func testExecute_returnsError_whenDelegateNotRescuingNonSuccessRescueResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restClient.maxRescueCount = 2
        restTransportEngine.results = [unauthorizedResponseResult(for: baseURL)]

        restClientDelegate.acceptsResponse = { _, _ in false }
        restClientDelegate.shouldRescueRequest = { request, _ in request.rescueCount < 1 }


        // Act
        var catchedError: Error?
        do {
            _ = try await restClient.response(forRequest: request, relativeTo: nil)
        } catch {
            catchedError = error
        }

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 8)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isPerformPreRequestFor, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isDidSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 3]?.isAcceptsResponse, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 4]?.isShouldRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 5]?.isRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 6]?.isAcceptsResponse, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 7]?.isShouldRescueRequest, true)
        XCTAssertNotNil(catchedError)
    }

    public func testExecute_returnsError_whenRequestRescueCountExceedsMaxRescueCount () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restClient.maxRescueCount = 2
        restTransportEngine.results = [unauthorizedResponseResult(for: baseURL)]

        restClientDelegate.acceptsResponse = { _, _ in false }
        restClientDelegate.shouldRescueRequest = { _, _ in true }

        // Act
        var catchedError: Error?
        do {
            _ = try await restClient.response(forRequest: request, relativeTo: nil)
        } catch {
            catchedError = error
        }

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 10)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isPerformPreRequestFor, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isDidSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 3]?.isAcceptsResponse, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 4]?.isShouldRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 5]?.isRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 6]?.isAcceptsResponse, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 7]?.isShouldRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 8]?.isRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 9]?.isAcceptsResponse, true)
        XCTAssertEqual(request.rescueCount, 2)
        XCTAssertNotNil(catchedError)
    }

    public func testExecute_returnsResponse_whenDelegateAcceptsNonSuccessRescuedResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restTransportEngine.results = [unauthorizedResponseResult(for: baseURL)]

        restClientDelegate.acceptsResponse = { _, _ in request.rescueCount > 0 }
        restClientDelegate.shouldRescueRequest = { _, _ in true }

        // Act
        let response = try? await restClient.response(forRequest: request, relativeTo: nil)

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 7)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isPerformPreRequestFor, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isDidSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 3]?.isAcceptsResponse, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 4]?.isShouldRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 5]?.isRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 6]?.isAcceptsResponse, true)
        XCTAssertEqual(request.rescueCount, 1)
        XCTAssertNotNil(response)
    }

    public func testExecute_returnsResponse_whenDelegateAcceptsSuccessRescuedResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restTransportEngine.results = [unauthorizedResponseResult(for: baseURL)]

        restClientDelegate.acceptsResponse = { response, _ in response.httpURLResponse.statusCode == 200 }
        restClientDelegate.shouldRescueRequest = { _, _ in true }
        restClientDelegate.rescueRequest = { request, _ in RestTransportEngineResponse(httpURLResponse: .ok(for: self.baseURL)!) }

        // Act
        let response = try? await restClient.response(forRequest: request, relativeTo: nil)

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 6)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isPerformPreRequestFor, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isDidSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 3]?.isAcceptsResponse, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 4]?.isShouldRescueRequest, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 5]?.isRescueRequest, true)
        XCTAssertEqual(request.rescueCount, 1)
        XCTAssertNotNil(response)
    }

    public func testExecute_returnsResponse_whenDelegateAcceptsNonSuccessResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restTransportEngine.results = [unauthorizedResponseResult(for: baseURL)]
        restClientDelegate.acceptsResponse = { _, _ in true }

        // Act
        let response = try? await restClient.response(forRequest: request, relativeTo: nil)

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isPerformPreRequestFor, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isDidSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 3]?.isAcceptsResponse, true)
        XCTAssertNotNil(response)
    }

    public func testExecute_returnsResponse_whenTransportEngineReturnsSuccessResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restTransportEngine.results = [okResponseResult(for: baseURL)]
        restClientDelegate.acceptsResponse = { _, _ in true }

        // Act
        let response = try? await restClient.response(forRequest: request, relativeTo: nil)

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isPerformPreRequestFor, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isDidSend, true)
        XCTAssertNotNil(response)
    }


    // MARK: - Void Response Tests

    public func testExecute_returnsError_whenReponseMethodFails_forVoidResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        let transportEngineError = URLError(.notConnectedToInternet)
        restTransportEngine.results = [.failure(transportEngineError)]

        // Act
        var catchedError: Error?
        do {
            _ = try await restClient.response(forRequest: request, relativeTo: nil)
        } catch {
            catchedError = error
        }

        // Assert
        XCTAssertNotNil(catchedError)
    }

    public func testExecute_returnsResponse_whenReponseMethodSucceeds_forVoidResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restTransportEngine.results = [okResponseResult(for: baseURL)]

        // Act
        let response = try? await restClient.send(request: request, relativeTo: nil)

        // Assert
        XCTAssertNotNil(response)
    }

    // MARK: - Object Response Tests

    public func testExecute_returnsError_whenReponseMethodFails_forObjectResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        let transportEngineError = URLError(.notConnectedToInternet)
        restTransportEngine.results = [.failure(transportEngineError)]

        // Act
        var catchedError: Error?
        do {
            _ = try await restClient.send(request: request, relativeTo: nil, expecting: User.self)
        } catch {
            catchedError = error
        }

        // Assert
        XCTAssertNotNil(catchedError)
    }

    public func testExecute_returnsError_whenReponseMethodReturnsInvalidData_forObjectResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        let transportEngineError = URLError(.notConnectedToInternet)
        restTransportEngine.results = [.failure(transportEngineError)]

        // Act
        var catchedError: Error?
        do {
            _ = try await restClient.send(request: request, relativeTo: nil, expecting: User.self)
        } catch {
            catchedError = error
        }

        // Assert
        XCTAssertNotNil(catchedError)
    }

    public func testExecute_returnsResponse_whenReponseMethodSucceeds_forObjectResponse () async {
        // Assign
        let request = restClient.makeRequest(at: "user/data")
        restTransportEngine.results = [okResponseResult(for: baseURL, data: userData)]

        // Act
        let response = try? await restClient.send(request: request, relativeTo: nil, expecting: User.self)

        // Assert
        XCTAssertNotNil(response?.data.email)
        XCTAssertNotNil(response?.data.username)
    }

    // MARK: - Helper Methods

    func unauthorizedResponseResult (for url: URL, data: Data? = nil) -> Result<RestTransportEngineResponse, Error> {
        .success(.init(httpURLResponse: .unauthorized(for: url, headers: nil)!, data: data))
    }

    func okResponseResult (for url: URL, data: Data? = nil) -> Result<RestTransportEngineResponse, Error> {
        .success(.init(httpURLResponse: .ok(for: url, headers: nil)!, data: data))
    }
}
