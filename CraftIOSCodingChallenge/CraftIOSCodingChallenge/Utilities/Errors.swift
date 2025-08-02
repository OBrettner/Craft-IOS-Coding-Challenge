
enum PersistencyError: Error {
    case encodingFailed
    case failedToSaveData
    case failedToLoadData
}
