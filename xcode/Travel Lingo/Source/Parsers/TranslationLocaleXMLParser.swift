//
//  TranslationLocaleXMLParser.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 20/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

class TranslationLocaleXMLParser: NSObject, NSXMLParserDelegate
{
    private var result: TranslationLocale?
    
    private var phrases = [TranslationPhrase]()
    private var groupings = [TranslationPhraseGrouping]()
    
    private var currentGrouping: TranslationPhraseGrouping?
    
    
    class func parseData(data: NSData) -> TranslationLocale?
    {
        let parser = TranslationLocaleXMLParser()
        return parser.parseData(data)
    }
    
    
    func parseData(data: NSData) -> TranslationLocale?
    {
        // reinitialize state
        phrases.removeAll()
        groupings.removeAll()
        
        // setup parser
        let dataParser = NSXMLParser(data: data)
        dataParser.delegate = self
        
        dataParser.shouldProcessNamespaces = false
        dataParser.shouldReportNamespacePrefixes = false
        dataParser.shouldResolveExternalEntities = false
        
        dataParser.parse()
        return result
    }
    
    
// MARK: XML Parser Delegate
    
    func parserDidStartDocument(parser: NSXMLParser)
    {
    }
    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        result?.phraseGroupings = groupings
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        // process translation-data tag
        if elementName == "translation"
        {
            if let language = attributeDict["language"],
                   countryCodeForFlag = attributeDict["country-code-for-flag"]
            {
                result = TranslationLocale(language: language, countryCode: countryCodeForFlag)
            }
        }
            
        // process grouping tag
        else if elementName == "grouping"
        {
            phrases.removeAll()
            currentGrouping = nil
            
            if let title = attributeDict["title"]
            {
                currentGrouping = TranslationPhraseGrouping(title: title)
                groupings.append(currentGrouping!)
            }
        }
            
        // process item tag
        else if elementName == "item"
        {
            if let phrase = attributeDict["phrase"],
               let translation = attributeDict["translation"],
               let audioFile = attributeDict["audio-file"]
            {
                let native = attributeDict["native"]
                
                let data = TranslationPhrase(phrase: phrase, translation: translation, native: native, audioFile: audioFile)
                phrases.append(data)
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "grouping"
        {
            if currentGrouping != nil
            {
                currentGrouping!.phrases = phrases
                currentGrouping = nil
            }
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
    }
    
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError)
    {
        let msg = NSLocalizedString("Unable to parse translation locale XML: %@", comment: "")
        AppLog(msg, parseError.localizedDescription)
    }
}

