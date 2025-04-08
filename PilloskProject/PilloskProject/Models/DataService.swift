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
    func loadData(completion: @escaping (Result<[ProductData], Error>) -> Void) {
        guard let path = Bundle.main.url(forResource: "Resources/data", withExtension: "json") else {
            completion(.failure(DataError.fileNotFound))
            return
        }
            
            do {
                let data = try Data(contentsOf: URL(filePath: "Resources/data"))
                let ProductData = try JSONDecoder().decode(ProductData.self, from: data)
                completion(.success([ProductData]))
            }
            catch {
                print("data passingFailed")
                completion(.failure(DataError.parsingFailed))
            }
    }
}
