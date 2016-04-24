//
//  TranslationLocaleUtils.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 24/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

func loadLocaleTranslations() -> [TranslationLocale]?
{
    guard let mappings = DataStore.sharedStore.objectForKey(Iso639LanguageMappingsDataStoreKey) as? [Iso639LanguageMapping] else {
        return nil
    }
    
    let locales: [TranslationLocale] = mappings.flatMap { loadTranslationLocaleForLanguage($0.language) }
    
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
    
    return sorted
}


private func loadTranslationLocaleForLanguage(language: String) -> TranslationLocale?
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


func translationLocaleForLanguage(lang: String) -> TranslationLocale?
{
    if let locales = DataStore.sharedStore.objectForKey(TranslationLocalesDataStoreKey) as? [TranslationLocale]
    {
        for locale in locales
        {
            if locale.language == lang {
                return locale
            }
        }
    }
    
    return nil
}
