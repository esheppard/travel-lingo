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
        let defaultValues: [String: AnyObject] = [
            HomeLanguageKey: "english"
        ]
        
        defaults.registerDefaults(defaultValues)
    }


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
}
