//
//  main.swift
//  CH03_CAStreamFormatTester
//
//  Created by wang on 2018/5/3.
//  Copyright © 2018 wang. All rights reserved.
//

import Foundation
import AudioToolbox

//1
var fileTypeAndFormat = AudioFileTypeAndFormatID()
fileTypeAndFormat.mFileType = kAudioFileAIFFType
fileTypeAndFormat.mFormatID = kAudioFormatLinearPCM

//2
var audioErr = noErr
var infoSize:UInt32 = 0

//3
audioErr = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, UInt32(MemoryLayout<AudioFileTypeAndFormatID>.stride), &fileTypeAndFormat, &infoSize)
assert(audioErr == noErr)

//4
var asbds = UnsafeMutablePointer<AudioStreamBasicDescription>.allocate(capacity: Int(infoSize))
//5
audioErr = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, UInt32(MemoryLayout<AudioFileTypeAndFormatID>.stride), &fileTypeAndFormat, &infoSize, asbds)
assert(audioErr == noErr)

//6
let asbdCount = Int(infoSize) / MemoryLayout<AudioStreamBasicDescription>.stride
for i in 0..<asbdCount {
    //7
    var format4cc = asbds[i].mFormatID.bigEndian
    //8
    withUnsafePointer(to: &format4cc) {
        print(String(format:"%d: mFormatId: %4.4s, mFormatFlags: %d, mBitsPerChannel: %d",i,$0, asbds[i].mFormatFlags, asbds[i].mBitsPerChannel))
    }
    
}

free(asbds)
exit(0)























