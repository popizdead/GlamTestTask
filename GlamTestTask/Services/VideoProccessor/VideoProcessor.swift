//
//  VideoProcessor.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 16/03/2023.
//

import AVFoundation

class VideoProcessor {
    
    // MARK: - Public methods
    func mergeVideosFrom(transitions: [URL]) async throws -> URL {
        let composition = AVMutableComposition()
        let onlyVideoTrack = try await addAssetsTo(composition: composition, assets: transitions)
        let video = try await addAudioTo(composition: onlyVideoTrack)
        return try await exportVideo(from: video)
    }
    
    // MARK: - Audio
    private func addAudioTo(composition: AVMutableComposition) async throws -> AVMutableComposition {
        guard let url = Bundle.main.url(forResource: "music", withExtension: "aac")
        else { throw VideoRender.VideoCreatorError.general }
        
        let audioAsset = AVURLAsset(url: url)
        guard let loadedAudio = try await audioAsset.loadTracks(withMediaType: .audio).first
        else { throw VideoRender.VideoCreatorError.general }
        
        let audioTrack = composition.addMutableTrack(withMediaType: .audio,
                                                     preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let videoDuration = composition.duration
        let audioRange = CMTimeRangeMake(start: .zero, duration: videoDuration)
        
        try audioTrack?.insertTimeRange(audioRange,
                                        of: loadedAudio,
                                        at: .zero)
        
        return composition
    }
    
    
    // MARK: - Video
    private func addAssetsTo(composition: AVMutableComposition,
                             assets: [URL]) async throws -> AVMutableComposition {
        guard let videoTrack = composition.addMutableTrack(withMediaType: .video,
                                                     preferredTrackID: kCMPersistentTrackID_Invalid)
        else { throw VideoRender.VideoCreatorError.general }
        var lastPosition: CMTime = .zero
        
        for asset in assets {
            let transitionDuration = try await insertAsset(to: videoTrack,
                                                           asset: asset,
                                                           position: lastPosition)
            lastPosition = CMTimeAdd(lastPosition, transitionDuration)
        }
        
        return composition
    }
    
    private func insertAsset(to video: AVMutableCompositionTrack,
                             asset: URL,
                             position: CMTime) async throws -> CMTime {
        let transitionAsset = AVURLAsset(url: asset)
        let transition = try await transitionAsset.loadTracks(withMediaType: .video).first!
        let duration   = try await transitionAsset.load(.duration)
        let timeRange  = CMTimeRangeMake(start: .zero, duration: duration)
        try video.insertTimeRange(timeRange, of: transition, at: position)
        return duration
    }
    
    private func exportVideo(from video: AVMutableComposition) async throws -> URL {
        let exporter = AVAssetExportSession(asset: video,
                                            presetName: AVAssetExportPresetHighestQuality)
        let name = UUID().uuidString
        let newUrl = try CacheManager.createFile(name: name, ext: "mp4")
        exporter?.outputURL = newUrl
        exporter?.outputFileType = .mp4
        await exporter?.export()
        return newUrl
    }
}
