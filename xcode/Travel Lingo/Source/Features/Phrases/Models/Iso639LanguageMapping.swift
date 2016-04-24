//
//  Iso639LanguageMapping.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 20/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

class Iso639LanguageMapping
{
    let language: String
    
    let iso6391Code: String?
    let iso6393Code: String?
    
    let name: String?
    
    
    init(language: String, iso6391Code: String)
    {
        self.name = nil
        self.language = language
        
        self.iso6391Code = iso6391Code
        self.iso6393Code = nil
    }
    
    init(language: String, iso6393Code: String, name: String)
    {
        self.name = name
        self.language = language
        
        self.iso6391Code = nil
        self.iso6393Code = iso6393Code
    }
}

