//
//  Iso639MappingUtils.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 22/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation


func displayStringForLanguage(language: String) -> String?
{
    guard let homeLanguage = Preferences.sharedPrefs.homeLanguage else {
        return nil
    }
    
    guard let homeMapping = iso639MappingForLanguage(homeLanguage) else {
        return nil
    }
    
    if let languageMapping = iso639MappingForLanguage(language)
    {
        // check if we have an ISO 639-1 code for this language - we can use it to have the
        // system provide us with the correct name
        if let iso6391 = languageMapping.iso6391Code, homeIso6391 = homeMapping.iso6391Code
        {
            let locale = NSLocale(localeIdentifier: homeIso6391)
            
            let name = locale.displayNameForKey(NSLocaleLanguageCode, value: iso6391)
            return name?.capitalizedStringWithLocale(locale)
        }
        
        // otherwise if we have a ISO 639-3 code use it to find the manually localized name
        else if let _ = languageMapping.iso6393Code, name = languageMapping.name
        {
            return NSLocalizedString(name, comment: "")
        }
    }
    
    return nil
}


func iso639MappingForLanguage(language: String) -> Iso639LanguageMapping?
{
    guard let mappings = DataStore.sharedStore.objectForKey(Iso639LanguageMappingsDataStoreKey) as? [Iso639LanguageMapping] else {
        return nil
    }
    
    for mapping in mappings
    {
        if mapping.language == language {
            return mapping
        }
    }
    
    return nil
}

