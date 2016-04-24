//
//  SettingsViewController.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 23/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController
{
    var sections = [SettingsSection]()
    
    var dirty: Bool = false
    var requiresReset: Bool = false
        
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureBarButtons()
        configureSettingsContent()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // ensure display states are refreshed to display any changes that may have been made
        if requiresReset
        {
            requiresReset = false
            configureSettingsContent()
        }
        
        tableView.reloadData()
        
        if dirty
        {
            NSNotificationCenter.defaultCenter().postNotificationName(SettingsDidChangeNotification, object: nil)
            dirty = false
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }


// MARK: - Configuration
    
    private func configureBarButtons()
    {
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: NSLocalizedString("Done", comment: ""),
                            style: .Done,
                            target: self,
                            action: #selector(doneAction(_:)))
    }
    
    
    private func configureSettingsContent()
    {
        sections.removeAll()
        addLanguageSection()
    }
    
    
    private func addLanguageSection()
    {
        let languageSection = SettingsSection(title: NSLocalizedString("Language", comment: ""))
        sections.append(languageSection)
        
        // -- home language --
        let homeLanguage = SettingsItem(title: NSLocalizedString("Home Language", comment: ""))
        
        homeLanguage.options = settingsOptionsForLanguages()
        homeLanguage.selectionChanged =
        {
            selected in
            
            if let selected = selected
            {
                // force a reload of all settings sections so they reload in the selected language
                self.dirty = true
                self.requiresReset = true
                
                Preferences.sharedPrefs.homeLanguage = selected.key
            }
        }
        
        if let homeLanguagePref = Preferences.sharedPrefs.homeLanguage {
            homeLanguage.selectedOption = homeLanguage.optionMatchingKey(homeLanguagePref)
        }
        
        languageSection.items.append(homeLanguage)
    }
    
    
// MARK: - Language Options
    
    private func settingsOptionsForLanguages() -> [SettingsOption]
    {
        var options = [SettingsOption]()
        
        guard let locales = DataStore.sharedStore.objectForKey(TranslationLocalesDataStoreKey) as? [TranslationLocale] else {
            return options
        }
        
        for locale in locales
        {
            let option = settingsOptionWithTranslationLocale(locale)
            options.append(option)
        }
        
        return options
    }
        
    private func settingsOptionWithTranslationLocale(locale: TranslationLocale) -> SettingsOption
    {
        let flag = locale.flagImage
        let title = displayStringForLanguage(locale.language) ?? ""
        
        return SettingsOption(key: locale.language, title: title, image: flag)
    }


// MARK: - Button Actions
    
    func doneAction(sender: AnyObject?)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
// MARK: - Table View Delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let settingsSection = sections[section]
        return settingsSection.items.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let settingsSection = sections[section]
        return settingsSection.title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath)
        
        let settingsItem = sections[indexPath.section].items[indexPath.row]
        
        cell.textLabel!.text = settingsItem.title
        cell.detailTextLabel!.text = settingsItem.selectedOption != nil ? settingsItem.selectedOption!.title : nil
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let settingsItem = sections[indexPath.section].items[indexPath.row]
        
        let optionsController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseOptionViewController") as! ChooseOptionViewController
        
        optionsController.title = settingsItem.title
        optionsController.settingsItem = settingsItem
        
        self.navigationController?.pushViewController(optionsController, animated: true)
    }
}
