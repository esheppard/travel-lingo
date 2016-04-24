//
//  TranslationLocale.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 19/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

class TranslationLocale
{
    let language: String
    let countryCodeForFlag: String
    
    var phraseGroupings = [TranslationPhraseGrouping]()
    
    
    init(language: String, countryCode: String)
    {
        self.language = language
        self.countryCodeForFlag = countryCode
    }
}
