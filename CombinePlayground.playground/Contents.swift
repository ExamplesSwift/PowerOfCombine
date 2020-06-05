import UIKit
import Combine

let url = URL(string: "https://applecodingacademy.com/testData/testImages.json")!

let publisher = URLSession.shared.dataTaskPublisher(for: url)
