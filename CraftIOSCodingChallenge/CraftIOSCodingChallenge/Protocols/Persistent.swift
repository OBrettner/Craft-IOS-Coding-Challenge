
import Foundation

protocol Persistent {
    associatedtype CodableData: Codable
    var codableData: CodableData {get set}
    var savedFilePath: URL {get}
    
    func save() throws
    mutating func load() throws
    
    init(data: CodableData)
}

extension Persistent {
    func save() throws {
        do {
            let data = try JSONEncoder().encode(self.codableData)
            try data.write(to: self.savedFilePath, options: [.atomic, .completeFileProtection])
        } catch {
            throw PersistencyError.failedToSaveData
        }
    }
    
    mutating func load() throws {
        do {
            let data = try Data(contentsOf: self.savedFilePath)
            self.codableData = try JSONDecoder().decode(CodableData.self, from: data)
        } catch {
            throw PersistencyError.failedToLoadData
        }
    }
}
