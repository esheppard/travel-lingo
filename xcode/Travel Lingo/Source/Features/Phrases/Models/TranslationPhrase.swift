//
//  TranslationPhrase.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 19/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

class TranslationPhrase
{
    let phrase: String
    
    let translation: String
    let native: String?
    
    let audioFile: String
    
    
    init(phrase: String, translation: String, native: String? = nil, audioFile: String)
    {
        self.phrase = phrase
        self.translation = translation
        self.native = native
        self.audioFile = audioFile
    }
}

