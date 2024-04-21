//
//  NetworkingManager.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 16.04.2024.
//

import Foundation
import Combine

final class NetworkingManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[🔥] Bad response from URL: \(url)"
            case .unknown:
                return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            ///(retry(3)) - bir hata oluştuğunda yayıncıyı yeniden denemek için kullanılır. Özellikle ağ çağrıları gibi dış kaynaklara bağlı işlemlerde kullanılabilir.
            ///Bu durumda, retry(3) çağrısı, yayıncı herhangi bir hata döndürdüğünde, hatalı işlemi 3 kez daha denemek için kullanılır. Yani, toplamda 4 deneme yapılacaktır (ilk deneme dahil). Eğer hata 3 deneme sonunda düzeltilmezse, hata yayıncı tarafından iletilir ve abonelere bildirilir.
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
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
