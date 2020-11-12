//
//  RestClient.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 29.10.20.
//

import Foundation

open class ApiClient: NSObject {

    /// Provides the delegate object to react on certain events of the client.
    public weak var delegate: ApiClientDelegate?

    /// Provides the engine for data transportation
    public var transportEngine: ApiClientTransportEngine

    /// Provides the object to use to decode the response data from the api.
    public var dataDecoder: ApiDataDecoder

    /// Provides the object to use to encode objects to data to send as payload to
    /// the api.
    public var dataEncoder: ApiDataEncoder

    /// Provides the default timeout, when delegate is not present or does not
    /// explicitly implement the timeout function.
    public var defaultTimeout: TimeInterval = 30.0

    /// Provides the object to build api requests
    public var requestBuilder: ApiRequestBuilder { ApiRequestBuilder(client: self) }

    /// Indicates whether to set the *Content-Type* header for the request, when
    /// setting payload by an encodable object or not. Default is set to `true`.
    public var requiresContentTypeForRequest: Bool = true

    /// Indicates whether to requires the response to specify the *Content-Type*
    /// header by setting the *Accept* header.
    public var requiresContentTypeFromResponse: Bool = true


    // MARK: Initialization

    /// Initializes the api client with the given delegate object.
    public init (transportEngine: ApiClientTransportEngine, decoder: ApiDataDecoder, encoder: ApiDataEncoder) {
        self.transportEngine = transportEngine
        self.dataDecoder = decoder
        self.dataEncoder = encoder
    }

    /// Invokes the client to send the given api
    public func send<D: Decodable> (apiRequest: ApiRequest, to baseUrl: URL) -> Promise<D> {
        do {
            delegate?.apiClient(self, willSendApiRequest: apiRequest)

            var urlRequest = try self.urlRequest(for: apiRequest, at: baseUrl)

            if let headers = urlRequest.allHTTPHeaderFields,
               !headers.contains(where: { $0.key.lowercased() == "accepts" }) &&
                requiresContentTypeFromResponse {
                urlRequest.addValue(dataDecoder.mimeType.description, forHTTPHeaderField: "Accepts")
            }

            apiRequest.urlRequest = urlRequest

            return transportEngine.send(urlRequest: urlRequest)
                .then({ data -> D in
                    try self.throwOnHttpErrorStatus(data.httpResponse, with: data.data, for: apiRequest)
                    return try self.process(D.self, httpResponse: data.httpResponse, data: data.data, for: apiRequest)
                })
                .catch({ error in
                    throw self.process(error: error, for: apiRequest)
                })
        } catch {
            delegate?.apiClient(self, didReceiveError: error, for: apiRequest)
            return Promise(error: error)
        }
    }

    /// Sends the request to the api at given url. Use this method, if no data
    /// object is expected to be returned in the response bod.
    public func send (apiRequest: ApiRequest, to baseUrl: URL) -> Promise<Void> {
        do {
            delegate?.apiClient(self, willSendApiRequest: apiRequest)
            let urlRequest = try self.urlRequest(for: apiRequest, at: baseUrl)

            return transportEngine.send(urlRequest: urlRequest)
                .then({
                    try self.throwOnHttpErrorStatus($0.httpResponse, with: $0.data, for: apiRequest)
                })
                .catch({ error in
                    throw self.process(error: error, for: apiRequest)
                })
        } catch {
            delegate?.apiClient(self, didReceiveError: error, for: apiRequest)
            return Promise(error: error)
        }
    }
    

    // MARK: Api Request Mapping

    /// Maps the api request into an url request.
    private func urlRequest (for apiRequest: ApiRequest, at apiBaseUrl: URL) throws -> URLRequest {

        /* The first thing to do is to determine how the api request parameters
         are translated - as url query parameters or body query parameters (e.g.
         for POST). Therefore, we need to determine the http method first. Only
         non-GET requests and requests with no payload data can have the request
         parameter translated to the body. If these conditions are met, we
         eventually ask the delegate if the client hsould translate. These three
         checks must be preserved, since not only building the url depends on
         this decision, but also the body of the url request, which in turn can
         only be built when the url has been generated. */

        // Map endpoints and path parameters to url components.
        var urlComponents = try self.urlComponents(for: apiRequest)


        // Determining the method and whether to translate paramaters to the
        // payload or not.

        let httpMethod = delegate?.apiClient(self, methodForApiRequest: apiRequest) ?? .GET
        let translateParametersToPayload = httpMethod != .GET && apiRequest.payload != nil &&
            (delegate?.apiClient(self, shouldTranslateParametersToPayloadForApiRequest: apiRequest) ?? true)


        // Map parameters to query items and append them to the url components
        // if applicable.

        let queryItems: [URLQueryItem] = apiRequest.parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })

        if !translateParametersToPayload && queryItems.count > 0 {
            var urlComponentsQueryItems = urlComponents.queryItems ?? []
            urlComponentsQueryItems.append(contentsOf: queryItems)
            urlComponents.queryItems = urlComponentsQueryItems
        }


        // Build the url with the given components relative to the base url.

        guard let url = urlComponents.url(relativeTo: apiBaseUrl) else {
            throw ApiRequestError(code: .invalidEndpoint, request: apiRequest)
        }


        // Now the base values for building a url request are given

        var request = URLRequest(url: url, timeoutInterval: delegate?.apiClient(self, timeoutForApiRequest: apiRequest) ?? defaultTimeout)
        request.httpMethod = httpMethod.rawValue
        apiRequest.headers.forEach({ request.addValue($0.name, forHTTPHeaderField: $0.value) })


        // Set the payload with the query items if not added to the url
        // components earlier.

        if translateParametersToPayload && queryItems.count > 0 {
            guard let data = queryItems.map({ "\($0)" }).joined(separator: "&").data(using: .utf8) else {
                throw ApiRequestError(code: .invalidParameter, request: apiRequest)
            }
            request.httpBody = data
        } else {
            request.httpBody = apiRequest.payload
        }


        // Contribute header data if needed
        if let headers = request.allHTTPHeaderFields,
           !headers.contains(where: { $0.key.lowercased() == "content-type" }) &&
            requiresContentTypeForRequest {
            request.addValue(dataDecoder.mimeType.description, forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    /// Maps the given endpoint and path parameters to a `URLComponents` object.
    /// Parameter values replace placeholders in the endpoint string given as
    /// _"/example/{param1}"_.
    private func urlComponents (for apiRequest: ApiRequest) throws -> URLComponents {
        guard let endpoint = apiRequest.endpoint else { return URLComponents() }

        let params = apiRequest.pathParameters
        let path = params.reduce(endpoint, { (result, param) -> String in
            result.replacingOccurrences(of: "{\(param.key)}", with: param.value)
        }).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)

        guard let p = path, let components = URLComponents(string: p) else {
            throw ApiRequestError(code: .invalidEndpoint, request: apiRequest)
        }

        return components
    }

    
    // MARK: Response and Request Handling

    private func throwOnHttpErrorStatus (_ httpResponse: HTTPURLResponse, with data: Data?, for apiRequest: ApiRequest) throws {
        let status = HttpStatus(httpResponse.statusCode)

        if let errorCode = apiResponseErrorCode(for: status) {
            throw ApiResponseError(code: errorCode,
                                   request: apiRequest,
                                   response: httpResponse,
                                   data: data)
        }
    }

    /// Processes the http response the api client received from the transport
    /// engine and maps it to an ApiResponse object.
    private func process<D: Decodable> (_ type: D.Type = D.self, httpResponse: HTTPURLResponse, data: Data?, for apiRequest: ApiRequest) throws -> D {
        guard let data = data else {
            throw ApiResponseError(code: .noResponseData,
                                   request: apiRequest,
                                   response: httpResponse,
                                   data: nil)
        }

        do {
            let content = try dataDecoder.decode(D.self, from: data)
            delegate?.apiClient(self, didReceiveApiResponse: content)
            return content
        } catch{
            throw ApiResponseError(code: .decodingError,
                                   request: apiRequest,
                                   response: httpResponse,
                                   data: data,
                                   previous: error)
        }
    }

    /// Returns the error code for the given http status.
    private func apiResponseErrorCode (for status: HttpStatus) -> ApiResponseError.Code? {
        switch status.category {
        case .serverError:
            return .serverError
        case .clientError:
            return .clientError
        case .unknown, .proprietaryError:
            return .internal
        default:
            return nil
        }
    }

    /// Will be invoked, when an api request fails before receiving a response.
    private func process (error: Error, for apiRequest: ApiRequest) -> Error {
        if let apiRequestError = error as? ApiRequestError {
            return apiRequestError
        }

        var code: ApiRequestError.Code = .internal
        if let error = error as? URLError {
            switch error.code {
            case .cancelled:
                code = .cancelled
            case .cannotConnectToHost:
                code = .serviceUnavailable
            case .dataNotAllowed, .notConnectedToInternet,
                 .internationalRoamingOff, .networkConnectionLost:
                code = .noInternetConnection
            case .timedOut:
                code = .timedOut
            default:
                code = .internal
            }
        }

        let apiRequestError = ApiRequestError(code: code, request: apiRequest, previous: error)
        delegate?.apiClient(self, didReceiveError: apiRequestError, for: apiRequest)
        return apiRequestError
    }
}

// MARK: -

/// Delegate class for the api client to get informed about certain events during
/// a api request.
public protocol ApiClientDelegate: class {

    /// Asks the delegate, whether the api request parameters should be
    /// translated as query items in the body.
    ///
    /// This will method will only be called, when the http method infered by the
    /// api action is not GET or the payload data has not been set.
    func apiClient (_ client: ApiClient, shouldTranslateParametersToPayloadForApiRequest apiRequest: ApiRequest) -> Bool

    /// Asks the delegate for the time interval in seconds to wait for until
    /// rasing a timeout error. The default value is given by the property
    /// `defaultTimeout` of the client.
    func apiClient (_ client: ApiClient, timeoutForApiRequest apiRequest: ApiRequest) -> TimeInterval

    /// Asks the delegate to map the api action in the given api request object to
    /// a apropriate http method.
    ///
    /// The default implementations maps api actions as follows:
    /// * `.retrieve` = `.GET`
    /// * `.create` = `.POST`
    /// * `.update` = `.PUT`
    /// * `.delete` = `.DELETE`
    func apiClient (_ client: ApiClient, methodForApiRequest apiRequest: ApiRequest) -> HttpMethod

    /// Tells the delegate, that the api client is about to send the given
    /// request.
    ///
    /// Developers can implement this method in order to put additional
    /// informations to the request, such as header or parameters.
    func apiClient (_ client: ApiClient, willSendApiRequest apiRequest: ApiRequest)

    /// Asks the delegate, whether pre action needs to be performed before the
    /// given api request or not.
    func apiClient (_ client: ApiClient, needsToPreformActionBefore apiRequest: ApiRequest) -> Bool

    /// Tells the delegate to perform an action before the given request.
    func apiClient (_ client: ApiClient, performActionBefore apiRequest: ApiRequest) -> Promise<Void>

    /// Tells the delegate, that the api client has received and decoded the
    /// response to the given object.
    func apiClient<D: Decodable> (_ client: ApiClient, didReceiveApiResponse apiResponse: D)

    /// Tells the delegate, that the api client has received an error during the
    /// process of sending an api request.
    func apiClient (_ client: ApiClient, didReceiveError error: Error, for request: ApiRequest)
}

// MARK: Default Implementations

public extension ApiClientDelegate {
    func apiClient (_ client: ApiClient, shouldTranslateParametersToPayloadForApiRequest apiRequest: ApiRequest) -> Bool { false }
    func apiClient (_ client: ApiClient, timeoutForApiRequest apiRequest: ApiRequest) -> TimeInterval { client.defaultTimeout }
    func apiClient (_ client: ApiClient, methodForApiRequest apiRequest: ApiRequest) -> HttpMethod {
        switch apiRequest.action {
        case .create:
            return .POST
        case .retrieve:
            return .GET
        case .update:
            return .PUT
        case .delete:
            return .DELETE
        @unknown default:
            fatalError()
        }
    }

    func apiClient (_ client: ApiClient, willSendApiRequest apiRequest: ApiRequest) {}
    func apiClient (_ client: ApiClient, needsToPreformActionBefore apiRequest: ApiRequest) -> Bool { false }
    func apiClient (_ client: ApiClient, performActionBefore apiRequest: ApiRequest) -> Promise<Void> { Promise() }
    func apiClient<D: Decodable> (_ client: ApiClient, didReceiveApiResponse apiResponse: D) {}
    func apiClient (_ client: ApiClient, didReceiveError error: Error, for request: ApiRequest) {}
}
