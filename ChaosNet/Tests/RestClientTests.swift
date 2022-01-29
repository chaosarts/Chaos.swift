//
//  RestClientTests.swift
//  Pods
//
//  Created by Fu Lam Diep on 30.12.21.
//

import XCTest
@testable import ChaosNet

public class RestClientTests: XCTestCase {

    let baseURL: URL? = URL(string: "https://test.com/api")

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

        restClient.delegate = restClientDelegate

        do {
            let data = try Data(contentsOf: dataURL)
            user = try JSONDecoder().decode(User.self, from: data)
            userData = try JSONEncoder().encode(User(username: "John Doe", email: "john.doe@chaosarts.de"))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    public func testExecute_sendsURLRequest () async {
        // Assign
        let requests = [
            RestRequest("user/data")
                .setQueryParameter("query1", value: "value")
                .setQueryParameter("query2", value: nil)
                .setHeader("header1", value: "headerValue")
                .setPayload("".data(using: .utf8)),
            RestRequest("https://net.chaos.de/user/data")
        ]

        // Act

        for request in requests {
            _ = try? await restClient.send(request: request, relativeTo: URL(string: "https://net.chaosarts.de"))
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
        let request = RestRequest("hps://fulam@chrono24:bam")

        // Act
        var catchedError: Error?
        do {
            _ = try await restClient.send(request: request, relativeTo: nil)
        } catch {
            catchedError = error
        }

        XCTAssertNotNil(catchedError)
    }

    public func testExecute_returnsError_whenSendingRequestFails_forVoidResponse () async {
        // Assign
        let request = RestRequest("user/data")
        let transportEngineError = URLError(.badURL)
        restTransportEngine.results = [.failure(transportEngineError)]

        // Act
        var restClientError: RestInternalError?
        do {
            _ = try await restClient.send(request: request, relativeTo: nil)
        } catch let error as RestInternalError {
            restClientError = error
        } catch {

        }

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 2)
        XCTAssertEqual(restClientDelegate.callHistory[0].isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[1].isSendingRequestDidFailWithError, true)
        XCTAssertEqual(restClientDelegate.callHistory[1].isDidSend, false)
        XCTAssertEqual(restClientError?.code, .engine)
        XCTAssertEqual(restClientError?.previous as? URLError, transportEngineError)
    }

    public func testExecute_delegateCallSequence_whenRestClientReceivesSuccessResponse_forVoidResponse() async {
        // Assign
        let request = RestRequest("user/data")

        // Act
        let response = try? await restClient.send(request: request, relativeTo: nil)

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 3)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 0]?.isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isDidSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 1]?.isSendingRequestDidFailWithError, false)
        XCTAssertEqual(restClientDelegate.callHistory[safe: 2]?.isDidProduceRestResponse, true)
        XCTAssertNotNil(response)
    }


    public func testExecute_delegateCallSequence_whenSendingRequestFails_forObjectResponse () async {
        // Assign
        let request = RestRequest("user/data")
        let transportEngineError = URLError(.badURL)
        restTransportEngine.results = [.failure(transportEngineError)]

        // Act
        var restClientError: RestInternalError?
        do {
            _ = try await restClient.send(request: request, relativeTo: nil, expecting: User.self)
        } catch let error as RestInternalError {
            restClientError = error
        } catch {

        }

        // Assert
        XCTAssertEqual(restClientDelegate.callHistory.count, 2)
        XCTAssertEqual(restClientDelegate.callHistory[0].isWillSend, true)
        XCTAssertEqual(restClientDelegate.callHistory[1].isSendingRequestDidFailWithError, true)
        XCTAssertEqual(restClientDelegate.callHistory[1].isDidSend, false)
        XCTAssertEqual(restClientError?.code, .engine)
        XCTAssertEqual(restClientError?.previous as? URLError, transportEngineError)
    }
}
