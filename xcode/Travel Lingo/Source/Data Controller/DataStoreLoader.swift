//
//  DataStoreLoader.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 23/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation


func populateDataStore()
{
    loadIso639LanguageMappings()
    loadLocaleTranslations()
}


private func loadIso639LanguageMappings()
{
    let file = "iso639_to_language_mappings"
    
    if let resourcePath = NSBundle.mainBundle().pathForResource(file, ofType: "xml")
    {
        if let data = NSData(contentsOfFile: resourcePath)
        {
            let mappings = Iso639LanguageMappingsXMLParser.parseData(data)
            DataStore.sharedStore.setObject(mappings, forKey: Iso639LanguageMappingsDataStoreKey)
        }
        else
        {
            let msg = NSLocalizedString("Unable to read content of %@ xml", comment: "")
            AppLog(.Error, .AlertUser, msg, file)
        }
    }
    else
    {
        let msg = NSLocalizedString("Unable to open %@ xml", comment: "")
        AppLog(.Error, .AlertUser, msg, file)
    }
}


private func loadLocaleTranslations()
{
    guard let mappings = DataStore.sharedStore.objectForKey(Iso639LanguageMappingsDataStoreKey) as? [Iso639LanguageMapping] else {
        return
    }
    
    let locales: [TranslationLocale] = mappings.flatMap { translationDataForLanguage($0.language) }
    
    let sorted = locales.sort
        {
            if let display0 = displayStringForLanguage($0.language),
                display1 = displayStringForLanguage($1.language)
            {
                return display0 < display1
            }
            else
            {
                return false
            }
    }
    
    DataStore.sharedStore.setObject(sorted, forKey: TranslationLocalesDataStoreKey)
}


private func translationDataForLanguage(language: String) -> TranslationLocale?
{
    let file = String(format: "%@_phrases", language)
    
    if let resourcePath = NSBundle.mainBundle().pathForResource(file, ofType: "xml")
    {
        if let data = NSData(contentsOfFile: resourcePath)
        {
            return TranslationLocaleXMLParser.parseData(data)
        }
    }
    
    return nil
}
