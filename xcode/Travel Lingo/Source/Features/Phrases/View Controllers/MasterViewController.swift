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

    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


// MARK: - View Controller Delegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        registerNotifications()
        
        configureDisplayLocales()
        configureNavigationButtons()
    }

    
    override func viewWillAppear(animated: Bool)
    {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        
        super.viewWillAppear(animated)
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
        let image = UIImage(named: "settings-icon")?.imageWithRenderingMode(.AlwaysTemplate)
        
        let settingsButton = UIBarButtonItem(image: image, style: .Plain,target: self, action: #selector(showSettings(_:)))
        settingsButton.tintColor = UIColor.blackColor()
        
        self.navigationItem.rightBarButtonItem = settingsButton
        
        // back button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        navigationItem.backBarButtonItem = backItem
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
        tableView.reloadData()
    }
    
    
// MARK: - Button Actions
    
    func showSettings(sender: AnyObject)
    {
        if let settingsController = self.storyboard!.instantiateViewControllerWithIdentifier("SettingsNavigationController") as? UINavigationController
        {
            if UI_USER_INTERFACE_IDIOM() == .Pad {
                settingsController.modalPresentationStyle = .FormSheet
            }
            
            self.splitViewController?.presentViewController(settingsController, animated: true, completion: nil)
        }
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
        Preferences.sharedPrefs.lastLanguage = localeData.language
        
        if UI_USER_INTERFACE_IDIOM() == .Phone
        {
            let phrasesController = self.storyboard!.instantiateViewControllerWithIdentifier("PhrasesViewController") as! PhrasesViewController
            phrasesController.localeData = localeData
            
            self.navigationController?.pushViewController(phrasesController, animated: true)
        }
        else if UI_USER_INTERFACE_IDIOM() == .Pad
        {
            if let detailNavigation = self.splitViewController?.viewControllers.last as? UINavigationController
            {
                if let phrasesController = detailNavigation.viewControllers.first as? PhrasesViewController {
                    phrasesController.localeData = localeData
                }
            }
        }
    }
}

