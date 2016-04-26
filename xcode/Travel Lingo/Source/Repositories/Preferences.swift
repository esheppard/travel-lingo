//
//  Preferences.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 20/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation


private let HomeLanguageKey = "homeLanguage"
private let LastLanguageKey = "lastLanguage"

private let defaults = NSUserDefaults.standardUserDefaults()


private let _PreferencesInstance = Preferences()

class Preferences
{
    class var sharedPrefs: Preferences
    {
        return _PreferencesInstance
    }
    
    private init()
    {
        registerDefaults()
    }

// MARK: - Values

    var homeLanguage: String?
    {
        set
        {
            defaults.setObject(newValue!, forKey: HomeLanguageKey)
            defaults.synchronize()
        }
        get
        {
            return defaults.stringForKey(HomeLanguageKey)
        }
    }
    
    var lastLanguage: String?
    {
        set
        {
            defaults.setObject(newValue!, forKey: LastLanguageKey)
            defaults.synchronize()
        }
        get
        {
            return defaults.stringForKey(LastLanguageKey)
        }
    }
    
    
// MARK: - Setup
    
    private func registerDefaults()
    {
        var defaultValues: [String: AnyObject] = [
            HomeLanguageKey: "english",
            LastLanguageKey: "arabic"
        ]
        
        // find the users preferred language
        if let languageCode = preferredLanguageCodeIso639()
        {
            if let mapping = iso639MappingForLanguageCode(languageCode) {
                defaultValues[HomeLanguageKey] = mapping.language
            }
        }
        
        defaults.registerDefaults(defaultValues)
    }
}
