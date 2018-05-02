//
//  main.swift
//  CH02_CAToneFileGenerator
//
//  Created by wang on 2018/5/2.
//  Copyright © 2018 wang. All rights reserved.
//

import Foundation
import AudioToolbox

//1
let SAMPLE_RATE: Float64 = 44100
//2
let DURATION = 5.0
//3
let FILENAME_FORMAT = "%0.3f-square.aif"

if CommandLine.argc < 2 {
    print("Usage: CAToneFileGenerator n\n(where n is tone in Hz)")
    exit(0)
}
print(CommandLine.arguments)
//4
let hz = atof(CommandLine.arguments[1])
assert(hz > 0.0)

print("generating \(hz) hz tone")

//5
let fileName = String(format: FILENAME_FORMAT, hz)
let filePath = (FileManager.default.currentDirectoryPath as NSString).appendingPathComponent(fileName)
let fileUrl: CFURL = URL(fileURLWithPath: filePath) as CFURL

//Prepare the format
//6
var asbd = AudioStreamBasicDescription()

//8
asbd.mSampleRate = SAMPLE_RATE
asbd.mFormatID = kAudioFormatLinearPCM
asbd.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
asbd.mBitsPerChannel = 16
asbd.mChannelsPerFrame = 1
asbd.mFramesPerPacket = 1
asbd.mBytesPerFrame = 2
asbd.mBytesPerPacket = 2

//Set up the file
var audioFile: AudioFileID? = nil
var audioErr: OSStatus = noErr
//9
audioErr = AudioFileCreateWithURL(fileUrl, kAudioFileAIFFType, &asbd, AudioFileFlags.eraseFile, &audioFile)
guard audioFile != nil else { exit(0) }

assert(audioErr == noErr)

//Start writing samples
//10
let maxSampleCount = Int(SAMPLE_RATE * DURATION)
var sampleCount:Int64 = 0
var bytesToWrite:UInt32 = 2
//11
let wavelengthInSamples = Int(SAMPLE_RATE / hz)

while sampleCount < maxSampleCount {
    for i in 0...wavelengthInSamples {
        //Square wave
        //12,13
        var sample:sint16 = i<wavelengthInSamples/2 ? sint16.max.bigEndian : sint16.min.bigEndian
        
        //Saw wave
//        var sample:sint16 = (sint16(i)/sint16(wavelengthInSamples)*sint16.max*2 - sint16.max).bigEndian
//        var sample = Int16(((Double(i) / Double(wavelengthInSamples)) * Double(Int16.max) * 2) - Double(Int16.max)).bigEndian
        print(sample)
        //14
        audioErr = AudioFileWriteBytes(audioFile!, false, sampleCount*2, &bytesToWrite, &sample)
        assert(audioErr == noErr)
        //15
        sampleCount += 1
    }
}
//16
audioErr = AudioFileClose(audioFile!)
assert(audioErr == noErr)
print("wrote \(sampleCount) samples")

exit(0)























