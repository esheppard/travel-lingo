//
//  TranslationPhraseGrouping.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 19/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

class TranslationPhraseGrouping
{
    let title: String
    var phrases: [TranslationPhrase]
    
    
    init(title: String)
    {
        self.title = title
        self.phrases = [TranslationPhrase]()
    }
    
    convenience init(title: String, phrases: [TranslationPhrase])
    {
        self.init(title: title)
        self.phrases = phrases
    }
}
