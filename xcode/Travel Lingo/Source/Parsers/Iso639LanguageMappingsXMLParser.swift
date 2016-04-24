//
//  Iso639LanguageMappingsXMLParser.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 20/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

class Iso639LanguageMappingsXMLParser: NSObject, NSXMLParserDelegate
{
    private var result = [Iso639LanguageMapping]()
    
    
    class func parseData(data: NSData) -> [Iso639LanguageMapping]
    {
        let parser = Iso639LanguageMappingsXMLParser()
        return parser.parseData(data)
    }
    
    
    func parseData(data: NSData) -> [Iso639LanguageMapping]
    {
        // reinitialize state
        result.removeAll()
    
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
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        // process locale-mappings tag
        if elementName == "iso639-mappings"
        {
        }
            
        // process ISO 639-1 tag
        else if elementName == "iso6391"
        {
            if let language = attributeDict["language"],
                   languageCode = attributeDict["language-code"]
            {
                let mapping = Iso639LanguageMapping(language: language, iso6391Code: languageCode)
                result.append(mapping)
            }
        }
        
        // process ISO 639-3 tag
        else if elementName == "iso6393"
        {
            if let language = attributeDict["language"],
                   languageCode = attributeDict["language-code"],
                   name = attributeDict["en-name"]
            {
                let mapping = Iso639LanguageMapping(language: language, iso6393Code: languageCode, name: name)
                result.append(mapping)
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
    }
    
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError)
    {
        let msg = NSLocalizedString("Unable to parse ISO 639 mappings XML: %@", comment: "")
        AppLog(msg, parseError.localizedDescription)
    }
}

