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
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
// MARK: - View Controller Delegate

    override func viewDidLoad()
    {
        super.viewDidLoad()
        registerNotifications()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // only need to restore the previous language on the iPad as phrases are not visible by default on the iPhone
        if localeData == nil && UI_USER_INTERFACE_IDIOM() == .Pad {
            restoreLastLanguage()
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        disposeAndClearCache()
    }
    
    
// MARK: - Configuration
    
    private func configureView()
    {
        disposeAndClearCache()
        
        self.title = localeData != nil ? displayStringForLanguage(localeData!.language) : nil
        self.tableView.reloadData()
    }
    

// MARK: - Notifications
    
    private func registerNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(settingsChanged(_:)),
            name: SettingsDidChangeNotification,
            object: nil)
    }
    
    @objc func settingsChanged(notification: NSNotification)
    {
        configureView()
    }
    
    
// MARK: - Restoration
    
    private func restoreLastLanguage()
    {
        if let lastLanguage = Preferences.sharedPrefs.lastLanguage,
               lastLocaleData = translationLocaleForLanguage(lastLanguage)
        {
            localeData = lastLocaleData
            configureView()
        }
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
            var phrase = translationPhrase.phrase
            
            // try to find the phrase in our home language
            if let homeLanguage = Preferences.sharedPrefs.homeLanguage,
                   homeLocale = translationLocaleForLanguage(homeLanguage)
            {
                let homePhrase = homeLocale.phraseGroupings[indexPath.section].phrases[indexPath.row]
                phrase = homePhrase.native ?? homePhrase.translation
            }
 
            cell.phraseLabel.text = phrase
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
