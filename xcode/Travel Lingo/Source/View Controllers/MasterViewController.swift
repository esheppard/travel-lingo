//
//  MasterViewController.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 19/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController
{
    var displayLocales = [TranslationLocale]()


    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureNavigationButtons()
    }

    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        
        // populate the dataStore now that we can present AlertViews/errors to the user
        if DataStore.sharedStore.objectForKey(Iso639LanguageMappingsDataStoreKey) == nil
        {
            populateDataStore()
            configureDisplayLocales()
        }
        
        // only need to restore the previous language on the iPad as phrases are not visible by default on the iPhone
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            restoreLastLanguage()
        }
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    
        // deselect highlighted row
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }


// MARK: - Setup
    
    private func configureDisplayLocales()
    {
        if let locales = DataStore.sharedStore.objectForKey(TranslationLocalesDataStoreKey) as? [TranslationLocale]
        {
            self.displayLocales = locales
        }
    }
    
    private func configureNavigationButtons()
    {
        // settings button
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(showSettings(_:)))
        self.navigationItem.rightBarButtonItem = settingsButton
        
        // back button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        navigationItem.backBarButtonItem = backItem
    }
    
    
// MARK: - Restoration
    
    private func restoreLastLanguage()
    {
        var selectDisplayLocaleAtIndex = 0
        
        if let lastLanguage = Preferences.sharedPrefs.lastLanguage
        {
            for (index, localeData) in self.displayLocales.enumerate()
            {
                if localeData.language == lastLanguage {
                    selectDisplayLocaleAtIndex = index
                }
            }
        }
        
        let indexPath = NSIndexPath(forRow: selectDisplayLocaleAtIndex, inSection: 0)
        
        tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
        tableView(tableView, didSelectRowAtIndexPath: indexPath) // Note: have to manually call delegate
    }
    
    
// MARK: - Button Actions
    
    func showSettings(sender: AnyObject)
    {
    }


// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return displayLocales.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("LanguageSelectCell", forIndexPath: indexPath)

        let locale = displayLocales[indexPath.row]
        
        cell.textLabel!.text = displayStringForLanguage(locale.language)
        cell.imageView!.image = locale.flagImage
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let localeData = displayLocales[indexPath.row]
        let localeTitle = displayStringForLanguage(localeData.language)
        
        Preferences.sharedPrefs.lastLanguage = localeData.language
        
        if UI_USER_INTERFACE_IDIOM() == .Phone
        {
            let phrasesController = self.storyboard!.instantiateViewControllerWithIdentifier("PhrasesViewController") as! PhrasesViewController
            
            phrasesController.title = localeTitle
            phrasesController.localeData = localeData
            
            self.navigationController?.pushViewController(phrasesController, animated: true)
        }
        else if UI_USER_INTERFACE_IDIOM() == .Pad
        {
            if let detailNavigation = self.splitViewController?.viewControllers.last as? UINavigationController
            {
                if let phrasesController = detailNavigation.viewControllers.first as? PhrasesViewController
                {
                    phrasesController.title = localeTitle
                    phrasesController.localeData = localeData
                }
            }
        }
    }
}

