//
//  NetworkManager.swift
//  MusicApp1
//
//  Created by DalHyun Nam on 2023/04/01.
//

import Foundation

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

final class NetworkManager {
    

    static let shared = NetworkManager()
 
    private init() {}
    
    //let musicURL = "https://itunes.apple.com/search?media=music"
    
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void

    // 네트워킹 요청하는 함수 (음악데이터 가져오기)
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
        
    }
    

    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        //print(#function)
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
      
            if let musics = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(musics))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parseJSON(_ musicData: Data) -> [Music]? {
        //print(#function)
    
        // 성공
        do {
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
        // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

