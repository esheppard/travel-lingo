//
//  PhrasesViewController.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 20/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit
import AudioToolbox

class PhrasesViewController: UITableViewController
{
    var localeData: TranslationLocale?
    {
        didSet {
            configureView()
        }
    }
    
    private var soundCache = [String: SystemSoundID]()
    
    
    private func configureView()
    {
        disposeAndClearCache()
        tableView.reloadData()
    }

    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        disposeAndClearCache()
    }
    
    
// MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return localeData == nil ? 0 : 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let phraseGrouping = localeData?.phraseGroupings.first
        {
            return phraseGrouping.phrases.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhraseCell", forIndexPath: indexPath) as! PhraseCell
        
        if let translationPhrase = localeData?.phraseGroupings[indexPath.section].phrases[indexPath.row]
        {
            cell.phraseLabel.text = translationPhrase.phrase
            cell.translationLabel.text = translationPhrase.translation
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if let phraseGrouping = localeData?.phraseGroupings[section]
        {
            return NSLocalizedString(phraseGrouping.title, comment: "")
        }
        
        return nil
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return PhraseCell.height
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let phraseGrouping = localeData?.phraseGroupings[indexPath.section]
        {
            let phrase: TranslationPhrase = phraseGrouping.phrases[indexPath.row]
            
            playAudio(phrase.audioFile)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
// MARK: - Cache

    private func disposeAndClearCache()
    {
        for soundId in soundCache.values {
            AudioServicesDisposeSystemSoundID(soundId)
        }
        
        soundCache.removeAll()
    }

    private func cacheAudio(file: String)
    {
        if soundCache.keys.contains(file) {
            return
        }
        
        if let soundId = loadAudio(file) {
            soundCache[file] = soundId
        }
    }
    
    private func playAudio(file: String)
    {
        cacheAudio(file)
        
        if let soundId = soundCache[file] {
            AudioServicesPlaySystemSound(soundId)
        }
    }
}
