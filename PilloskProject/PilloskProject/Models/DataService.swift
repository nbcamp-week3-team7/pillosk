//
//  DataService.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/8/25.
//
import Foundation

class DataService {

    enum DataError: Error {
        case fileNotFound
        case parsingFailed
    }
    func loadData(completion: @escaping (Result<ProductData, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            completion(.failure(DataError.fileNotFound))
            return
        }

            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let productData = try JSONDecoder().decode(ProductData.self, from: data)
                completion(.success(productData))
            } catch {
                print("data passingFailed")
                completion(.failure(DataError.parsingFailed))
            }
    }
}
