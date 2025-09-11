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
    //Cancel the api call when call view did disappear and also used to avoid memory leak and also used to avoid long runnig task.
    var cancellables: Set<AnyCancellable> = []
    
    //Future is also a publisher which emits the response of the api over time
    //Future send the response(OUTPUT) back or error.
    func getData<T: Codable>(url: String, type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let self = self else { return }
            
            guard let apiUrl = URL(string: url) else {
                promise(.failure(ApiError.invalidUrl))
                return
            }
            //Datataskpublisher is the publisher which emits value
            URLSession.shared.dataTaskPublisher(for: apiUrl)
                //Try map is a operators which Check the response is valid or not
                .tryMap { (data, response) -> Data in
                    guard let apiResponse = response as? HTTPURLResponse,
                          200...299 ~= apiResponse.statusCode else {
                        throw ApiError.invalidResponse
                    }
                    return data
                }
            //Decode is the Operators for decode the response
                .decode(type: [T].self, decoder: JSONDecoder())
            //.receives is a scheduler which assign the response to main queue
                .receive(on: RunLoop.main)
            //.sink is a Subscriber which get the values from the publisher and handle both the closures
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
            //.store is used to handle the cancellables for to avoid memory leak and also stop api call when we call view did disappear
                .store(in: &self.cancellables)
        }
    }

}
