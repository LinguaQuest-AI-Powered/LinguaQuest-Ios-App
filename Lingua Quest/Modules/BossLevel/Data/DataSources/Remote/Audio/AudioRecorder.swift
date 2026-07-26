//
//  AudioRecorder.swift
//  Lingua Quest
//
//  Created by taqieallah on 24/07/2026.
//

import Foundation
import AVFoundation

final class AudioRecorder {
    private var audioEngine: AVAudioEngine?
    private var converter: AVAudioConverter?
    private var isRecording = false
    private var tapCount = 0
    private var lastLevelTime: TimeInterval = 0

    var onAudioLevelChanged: ((Float) -> Void)?

    // MARK: - Public

    func startRecording() -> AsyncStream<Data> {
        AsyncStream { continuation in
            print("🎙 [AudioRecorder] startRecording()")

            let engine = AVAudioEngine()
            self.audioEngine = engine
            let inputNode = engine.inputNode

            // Must be called AFTER AVAudioSession is active and category is set.
            let hwFormat = inputNode.outputFormat(forBus: 0)
            print("🎙 [AudioRecorder] HW format — SR:\(hwFormat.sampleRate) CH:\(hwFormat.channelCount)")

            guard hwFormat.sampleRate > 0, hwFormat.channelCount > 0 else {
                print("🎙 [AudioRecorder] ❌ Bad hardware format — is AVAudioSession active?")
                continuation.finish()
                return
            }

            // Target: mono, 16-bit int, 16 kHz — exactly what Gemini Live expects
            guard let targetFormat = AVAudioFormat(
                commonFormat: .pcmFormatInt16,
                sampleRate: 16_000,
                channels: 1,
                interleaved: true
            ) else {
                print("🎙 [AudioRecorder] ❌ Could not build target format")
                continuation.finish()
                return
            }

            guard let converter = AVAudioConverter(from: hwFormat, to: targetFormat) else {
                print("🎙 [AudioRecorder] ❌ Could not create AVAudioConverter")
                continuation.finish()
                return
            }
            // Downmix stereo → mono automatically
            converter.downmix = true
            // Optimize audio conversion quality (high-fidelity resampling)
            converter.sampleRateConverterQuality = AVAudioQuality.max.rawValue
            converter.sampleRateConverterAlgorithm = AVSampleRateConverterAlgorithm_Mastering
            self.converter = converter

            inputNode.removeTap(onBus: 0)
            // Use 100 ms worth of frames at hardware rate
            let bufferSize = AVAudioFrameCount(hwFormat.sampleRate * 0.1)

            inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: hwFormat) { [weak self] inBuffer, _ in
                guard let self, self.isRecording, inBuffer.frameLength > 0 else { return }

                self.tapCount += 1
                if self.tapCount <= 5 {
                    print("🎙 [AudioRecorder] Tap #\(self.tapCount) — \(inBuffer.frameLength) frames")
                }

                // Calculate output capacity
                let outFrameCapacity = AVAudioFrameCount(
                    ceil(Double(inBuffer.frameLength) * targetFormat.sampleRate / hwFormat.sampleRate)
                )
                guard outFrameCapacity > 0,
                      let outBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: outFrameCapacity)
                else { return }

                var convError: NSError?
                var provided = false

                let status = converter.convert(to: outBuffer, error: &convError) { _, outStatus in
                    if provided {
                        outStatus.pointee = .noDataNow
                        return nil
                    }
                    provided = true
                    outStatus.pointee = .haveData
                    return inBuffer
                }

                if let convError {
                    print("🎙 [AudioRecorder] Converter error: \(convError)")
                    return
                }
                guard status != .error, outBuffer.frameLength > 0,
                      let int16Ptr = outBuffer.int16ChannelData
                else { return }

                let byteCount = Int(outBuffer.frameLength) * 2
                let pcmData = Data(bytes: int16Ptr[0], count: byteCount)
                continuation.yield(pcmData)

                // Level meter ~10 Hz
                let now = Date().timeIntervalSinceReferenceDate
                if now - self.lastLevelTime >= 0.1 {
                    self.lastLevelTime = now
                    self.onAudioLevelChanged?(self.rmsLevel(inBuffer))
                }
            }

            do {
                engine.prepare()
                try engine.start()
                self.isRecording = true
                print("🎙 [AudioRecorder] ✅ Engine started")
            } catch {
                print("🎙 [AudioRecorder] ❌ Engine start error: \(error.localizedDescription)")
                inputNode.removeTap(onBus: 0)
                continuation.finish()
            }

            continuation.onTermination = { [weak self] _ in self?.stopRecording() }
        }
    }

    func stopRecording() {
        guard isRecording else { return }
        isRecording = false
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine?.stop()
        audioEngine = nil
        converter = nil
        tapCount = 0
        print("🎙 [AudioRecorder] Stopped")
    }

    // MARK: - Private

    private func rmsLevel(_ buffer: AVAudioPCMBuffer) -> Float {
        guard buffer.frameLength > 0, let ch = buffer.floatChannelData?[0] else { return 0 }
        let n = Int(buffer.frameLength)
        var sum: Float = 0
        for i in 0..<n { sum += ch[i] * ch[i] }
        return min(sqrt(sum / Float(n)) * 6, 1.0)
    }
}
