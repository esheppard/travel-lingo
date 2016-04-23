//
//  Utils.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 22/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

func fileExistsAtPath(path: String) -> Bool
{
    if path.characters.count == 0 {
        return false
    }
    
    return NSFileManager.defaultManager().fileExistsAtPath(path)
}

func resourcePathForFile(file: String) -> String?
{
    if file.characters.count == 0 {
        return nil
    }
    
    let name = file.lastPathComponent.stringByDeletingPathExtension
    let ext = file.pathExtension
    
    return NSBundle.mainBundle().pathForResource(name, ofType: ext)
}
