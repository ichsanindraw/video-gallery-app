//
//  NetworkManager.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import Combine
import Foundation
import Moya

public class NetworkManager<Target> where Target: TargetType  {
    private let provider: MoyaProvider<Target>
        
    init() {
        provider = MoyaProvider(
            plugins: [
                AuthPlugin(),
                LoggerPlugin()
            ]
        )
    }
    
    func request<D: Decodable>(
        _ target: Target,
        _ responseType: D.Type
    ) -> AnyPublisher<D, NetworkError> {
        let subject = PassthroughSubject<D, NetworkError>()
        
        provider.request(target) { result in
            switch result {
            case let .failure(error):
                print(">>> Moya Error: \(error)")
                subject.send(completion: .failure(.moyaError(error)))
                
            case let .success(response):
                do {
                    let successResponse = try response.map(D.self, failsOnEmptyData: false)
                    
                    subject.send(successResponse)
                    subject.send(completion: .finished)
                } catch {
                    do {
                        let errorResponse = try response.map(BaseError.self, failsOnEmptyData: false)

                        subject.send(completion: .failure(.common(error: errorResponse.error, statusCode: 200)))
                        subject.send(completion: .finished)
                    } catch {
                        #if DEBUG
                            print(">>> Error: \(error) from: \(responseType)")
                        #endif
                        
                        subject.send(completion: .failure(.moyaError(.jsonMapping(response))))
                    }
                }
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}

struct BaseError: Decodable & Error {
    let error: String
}

enum NetworkError: Error {
    case moyaError(MoyaError)
    case common(error: String, statusCode: Int)
    case detail([String])
    
    public var localizedDescription: String {
        switch self {
        case let .moyaError(error):
            return error.errorDescription ?? ""

        case let .common(error, statusCode):
            return "error: \(error) with status code: \(statusCode)"

        case let .detail(errors):
            return errors.first ?? ""
        }
    }
}

class LoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        print(">>> LoggerPlugin -> willSend")
        print("Request: \(request.request?.url?.absoluteString ?? "")")
        if let headers = request.request?.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let httpBody = request.request?.httpBody,
           let bodyString = String(data: httpBody, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print(">>> LoggerPlugin -> didReceive")
        switch result {
        case .success(let response):
            if let json = try? response.mapJSON() {
                print("Response: \(json)")
            } else {
                print("Response data: \(String(data: response.data, encoding: .utf8) ?? "Unable to convert data to string")")
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}
