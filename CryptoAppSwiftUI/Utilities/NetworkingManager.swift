//
//  NetworkingManager.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 16.04.2024.
//

import Foundation
import Combine

final class NetworkingManager {
    static func download(urlString: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkingError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
        ///(retry(3)) - bir hata oluştuğunda yayıncıyı yeniden denemek için kullanılır. Özellikle ağ çağrıları gibi dış kaynaklara bağlı işlemlerde kullanılabilir.
        ///Bu durumda, retry(3) çağrısı, yayıncı herhangi bir hata döndürdüğünde, hatalı işlemi 3 kez daha denemek için kullanılır. Yani, toplamda 4 deneme yapılacaktır (ilk deneme dahil). Eğer hata 3 deneme sonunda düzeltilmezse, hata yayıncı tarafından iletilir ve abonelere bildirilir.
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }
        
        switch response.statusCode {
        case 200...299:
            return output.data
        case 400:
            throw NetworkingError.invalidRequest
        case 401:
            throw NetworkingError.unauthorized
        case 402:
            throw NetworkingError.paymentRequired
        case 404:
            throw NetworkingError.pageNotFound
        default:
            throw NetworkingError.invalidHTTPStatusCode(statusCode: response.statusCode)
        }
    }

    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
