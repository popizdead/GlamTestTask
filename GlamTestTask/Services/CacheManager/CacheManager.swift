//
//  CacheManager.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 16/03/2023.
//

import Photos

class CacheManager {
    
    // MARK: - Properties
    private static let fileManager = FileManager.default
    
    // MARK: - Public methods
    static func createFile(name: String, ext: String) throws -> URL {
        let cacheDirectory = try getUrlOfCachesDirectory()
        let url = cacheDirectory.appendingPathComponent(name).appendingPathExtension(ext)
        return url
    }
    
    static func removeFileAtURL(fileURL: URL) {
        try? FileManager.default.removeItem(atPath: fileURL.path)
    }
    
    static func saveToLibrary(fileUrl: URL) async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        guard status == .authorized else { throw VideoRender.VideoCreatorError.general }
        
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl)
        }
    }
    
    // MARK: - Private methods
    private static func getUrlOfCachesDirectory() throws -> URL {
        return try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}
