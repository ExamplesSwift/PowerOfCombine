import UIKit
import Combine

struct JSONImages : Codable {
  let images: [String]
}

let url = URL(string: "https://applecodingacademy.com/testData/testImages.json")!

func getImage(url: URL) -> AnyPublisher<UIImage, Error> {
  URLSession.shared.dataTaskPublisher(for: url)
    .map {
      $0.data
  }
  .compactMap {
    UIImage(data: $0)
  }
  .mapError {
    $0 as Error
  }
  .eraseToAnyPublisher()
}

let publisher = URLSession.shared.dataTaskPublisher(for: url)
  .map { $0.data }
  .decode(type: JSONImages.self, decoder: JSONDecoder())
  .map { $0.images.first! }
  .map { URL(string: $0)! }
  .flatMap {
    getImage(url: $0)
}.eraseToAnyPublisher()

let subscriber = publisher.sink(receiveCompletion: { completion in
  switch completion {
  case .finished:
    print("Termino Correctamente")
  case .failure(let error):
    print("Ha ocurrido un Error: \(error)")
  }
}, receiveValue: { succes in
  print(succes)
  succes
})

