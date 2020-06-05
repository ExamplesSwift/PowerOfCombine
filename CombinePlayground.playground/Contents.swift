import UIKit
import Combine

let url = URL(string: "https://applecodingacademy.com/testData/testImages.json")!

let publisher = URLSession.shared.dataTaskPublisher(for: url)
  .map { $0.data }

let subscriber = publisher.sink(receiveCompletion: { completion in
  switch completion {
  case .finished:
    print("Termino Correctamente")
  case .failure(let error):
    print("Ha ocurrido un Error: \(error)")
  }
}, receiveValue: { succes in
  print(succes)
})

