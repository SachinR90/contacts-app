//
//  NetworkManager.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import Foundation

enum URLError: Error {
  case noData
  case networkFailure
}

class NetworkManager {
  @discardableResult
  func GET(url: String, params: [String: String], decoder: JSONDecoder = JSONDecoder(), complete: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTask? {
    guard var components = URLComponents(string: url) else {
      print("Error: cannot create URLCompontents")
      return nil
    }
    components.queryItems = params.map { key, value in
      URLQueryItem(name: key, value: value)
    }

    guard let url = components.url else {
      print("Error: cannot create URL")
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let config = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { data, response, error in
      guard error == nil else {
        print("Error: problem calling GET")
        print(error!)
        complete(.failure(error!))
        return
      }
      guard let data = data else {
        print("Error: did not receive data")
        complete(.failure(URLError.noData))
        return
      }
      guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
        print("Error: HTTP request failed")
        complete(.failure(URLError.networkFailure))
        return
      }
      complete(.success(data))
    }
    return task
  }
}
