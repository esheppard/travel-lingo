//
//  AudioUtils.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 22/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import AudioToolbox

func loadAudio(file: String) -> SystemSoundID?
{
    guard let resourcePath = resourcePathForFile(file) else {
        return nil
    }
    
    if !fileExistsAtPath(resourcePath) {
        return nil
    }
    
    let resourceUrl = NSURL(fileURLWithPath: resourcePath)
    
    var soundId: SystemSoundID = 0
    if AudioServicesCreateSystemSoundID(resourceUrl, &soundId) == 0 {
        return soundId
    }
    
    return nil
}
