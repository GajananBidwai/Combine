//
//  ApiHelper.swift
//  CombineExample
//
//  Created by Neosoft on 10/09/25.
//

import Foundation
import Combine
enum ApiError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case invalidDecoding
    case invalidError
    case unknown
}

class ApiHelper{
    
    static let shared = ApiHelper()
    var cancellables: Set<AnyCancellable> = []
    
    func getData<T: Codable>(url: String, type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let self = self else { return }
            
            guard let apiUrl = URL(string: url) else {
                promise(.failure(ApiError.invalidUrl))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: apiUrl)
                .tryMap { (data, response) -> Data in
                    guard let apiResponse = response as? HTTPURLResponse,
                          200...299 ~= apiResponse.statusCode else {
                        throw ApiError.invalidResponse
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            switch error {
                            case let decodingError as DecodingError:
                                promise(.failure(decodingError))
                            case let apiError as ApiError:
                                promise(.failure(apiError))
                            default:
                                promise(.failure(ApiError.unknown))
                            }
                        }
                    },
                    receiveValue: { value in
                        promise(.success(value))
                    }
                )
                .store(in: &self.cancellables)
        }
    }

}
