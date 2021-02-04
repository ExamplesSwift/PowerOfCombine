# Power Of Combine
This example show how you can download image from services

```
import Foundation
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


```

Con otra API:

```

import Foundation
import Combine
import UIKit

// MARK: - Welcome
struct Welcome: Codable {
    let page, perPage, total, totalPages: Int
    let data: [Datum]
    let support: Support

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data, support
    }
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}

// MARK: - Codigo

let url = URL(string: "https://reqres.in/api/users?page=1")!

func getImage(url: URL) ->  AnyPublisher<UIImage, Error> {
    
  URLSession.shared
    .dataTaskPublisher(for: url)
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

let publisher = URLSession.shared
  .dataTaskPublisher(for: url)
  .map {
    $0.data
  }
  .decode(type: Welcome.self, decoder: JSONDecoder())
  .map {
    $0.data
  }
  .flatMap {
    getImage(url: URL(string: $0[4].avatar)!)
  }
  .eraseToAnyPublisher()

let subscribe = publisher.sink(receiveCompletion: { completion in
  switch completion {
  case .finished:
    print("Termino Correctamente")
  case .failure(let error):
   print("Ha ocurrido un Error \(error)")
  }
}, receiveValue: { value in
//  print(value.data[1])
  print(value)
  value
})

```
