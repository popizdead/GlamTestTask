//
//  VideoRender.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 16/03/2023.
//

import UIKit
import AVFoundation

class VideoRender {
    
    enum VideoCreatorError: Error {
        case general
    }
    
    // MARK: - Properties
    private var size: CGSize = .zero
    private let avCodecKey = AVVideoCodecType.h264
    private let timescale: Int32 = 600
    
    var fileUrl: URL?
    
    private var videoWriter: AVAssetWriter?
    private var videoWriterInput: AVAssetWriterInput?
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    
    private var avOutputSettings: [String : Any] = [:]
    private var lastFrameSecond: Double = 0
    
    // MARK: - Public methods
    func create(size: CGSize) throws {
        self.size = size
        applyOutputSettings()
        
        try createUrlForFile()
        try createAssetWriter()
        try createAssetInput()
        try createPixelBufferAdaptor()
        
        try startSession()
    }
    
    func render() async throws {
        guard let videoWriterInput else { throw VideoCreatorError.general }
        let queue = DispatchQueue(label: "transitionRenderQueue")
        
        return try await withCheckedThrowingContinuation { continuation in
            videoWriterInput.requestMediaDataWhenReady(on: queue) {
                videoWriterInput.markAsFinished()
                self.videoWriter?.finishWriting {
                    continuation.resume()
                }
            }
        }
    }
    
    func addImage(_ image: UIImage, duration: Double) throws {
        guard let videoWriterInput else { throw VideoCreatorError.general }
        guard let pixelBufferAdaptor else { throw VideoCreatorError.general }
        
        guard videoWriterInput.isReadyForMoreMediaData else {
            try addImage(image, duration: duration)
            return
        }
        
        
        let time = CMTime(seconds: lastFrameSecond, preferredTimescale: timescale)
        let pixelBuffer = try pixelBufferFromImage(image: image)
        
        guard pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: time)
        else { throw VideoCreatorError.general }
        lastFrameSecond += duration
    }
    
    func addImages(_ images: [UIImage], fps: Int) throws {
        let frameDuration = CMTimeMake(value: Int64(timescale / Int32(fps)), timescale: timescale)
        for image in images {
            try addImage(image, duration: frameDuration.seconds)
        }
    }
    
    // MARK: - Private methods
    private func createUrlForFile() throws {
        let name = UUID().uuidString
        let url  = try CacheManager.createFile(name: name, ext: "mp4")
        fileUrl = url
    }
    
    private func applyOutputSettings() {
        avOutputSettings = [
            AVVideoCodecKey  :  avCodecKey,
            AVVideoWidthKey  :  NSNumber(value: Float(size.width)),
            AVVideoHeightKey :  NSNumber(value: Float(size.height))
        ]
    }
    
    private func startSession() throws {
        guard let videoWriter else { throw VideoCreatorError.general }
        guard videoWriter.startWriting() else { throw VideoCreatorError.general }
        videoWriter.startSession(atSourceTime: .zero)
    }
    
    private func createAssetWriter() throws {
        guard let fileUrl else {throw VideoCreatorError.general }
        let assetWriter = try AVAssetWriter(outputURL: fileUrl, fileType: AVFileType.mp4)
        
        guard assetWriter.canApply(outputSettings: avOutputSettings, forMediaType: AVMediaType.video)
        else { throw VideoCreatorError.general }
        
        videoWriter = assetWriter
    }
    
    private func createAssetInput() throws {
        videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: avOutputSettings)
        
        guard let videoWriter, let videoWriterInput else { throw VideoCreatorError.general }
        guard videoWriter.canAdd(videoWriterInput) else { throw VideoCreatorError.general }
        
        videoWriter.add(videoWriterInput)
    }
    
    private func createPixelBufferAdaptor() throws {
        guard let videoWriterInput else { throw VideoCreatorError.general }
        let sourcePixelBufferAttributesDictionary = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: NSNumber(value: Float(size.width)),
            kCVPixelBufferHeightKey as String: NSNumber(value: Float(size.height))
        ]
        
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: videoWriterInput,
            sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
    }
}

// MARK: - Helpers
private extension VideoRender {
    func pixelBufferFromImage(image: UIImage) throws -> CVPixelBuffer {
        let ciimage = CIImage(image: image)
        let tmpcontext = CIContext(options: nil)
        let cgimage = tmpcontext.createCGImage(ciimage!, from: ciimage!.extent)
        
        let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
        let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
        let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        let options: [String: Any] = [kCVPixelBufferCGImageCompatibilityKey as String: true, kCVPixelBufferCGBitmapContextCompatibilityKey as String: true]
        
        let width = Int(size.height)
        let height = Int(size.height)
        
        var pxbuffer: CVPixelBuffer?
        var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32BGRA, options as CFDictionary, &pxbuffer)
        guard status == kCVReturnSuccess && pxbuffer != nil else { throw VideoCreatorError.general }
        
        status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!);
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
        let context = CGContext(data: bufferAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesperrow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue);
        context?.concatenate(CGAffineTransform(rotationAngle: 0))
        context?.draw(cgimage!, in: CGRect(x:0, y:0, width:CGFloat(width), height:CGFloat(height)));
        status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        return pxbuffer!;
    }
}
