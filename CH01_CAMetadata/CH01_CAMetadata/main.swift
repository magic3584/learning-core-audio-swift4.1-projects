//
//  main.swift
//  CH01_CAMetadata
//
//  Created by wang on 2018/4/28.
//  Copyright © 2018 wang. All rights reserved.
//

import Foundation
import AudioToolbox

if CommandLine.argc < 2 {
    print("Usage: CAMetadata /full/path/to/audiofile\n")
    exit(0)
}
print(CommandLine.arguments)

if  let audioFilePath = NSString(utf8String: CommandLine.arguments[1])?.expandingTildeInPath {
    let url = URL(fileURLWithPath: audioFilePath)
    var audioFile: AudioFileID? = nil
    var theErr = noErr
    theErr = AudioFileOpenURL(url as CFURL, AudioFilePermissions.readPermission, 0, &audioFile)
    assert(theErr == noErr)
    
    
    guard audioFile != nil else { exit(0) }
    var dictionarySize: uint32 = 0
    var isWritable: uint32 = 0
    theErr = AudioFileGetPropertyInfo(audioFile!, kAudioFilePropertyInfoDictionary, &dictionarySize, &isWritable)
    assert(theErr == noErr)

    
    var dictionary: CGPDFDictionaryRef? = nil
    theErr = AudioFileGetProperty(audioFile!, kAudioFilePropertyInfoDictionary, &dictionarySize, &dictionary)
    assert(theErr == noErr)

//    print("dictionary: %@", dictionary)
//    CGPDFDictionaryApplyFunction(dictionary!, { (key, object, info) -> Void in
//        print("\(key), \(object), \(info)")
//    }, nil)
    
    theErr = AudioFileClose(audioFile!)
    assert(theErr == noErr)
    
    exit(0)
}


