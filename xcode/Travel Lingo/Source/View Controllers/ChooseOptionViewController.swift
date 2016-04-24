//
//  ChooseOptionViewController.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 24/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

class ChooseOptionViewController: UITableViewController
{
    var settingsItem: SettingsItem?
 
    
// MARK: - Table View Delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return settingsItem != nil ? settingsItem!.options.count : 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("OptionCell", forIndexPath: indexPath)
        
        let option = settingsItem!.options[indexPath.row]
        
        cell.textLabel!.text = option.title
        cell.imageView!.image = option.image
        
        if let selectedOption = self.settingsItem!.selectedOption where option == selectedOption
        {
            cell.textLabel!.textColor = UIColor.tableItemSelectionColor
            cell.accessoryType = .Checkmark;
        }
        else
        {
            cell.textLabel!.textColor = UIColor.darkTextColor()
            cell.accessoryType = .None;
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // update previous cell
        if let previousOption = settingsItem!.selectedOption,
           let indexOfPreviousOption = settingsItem!.options.indexOf(previousOption)
        {
            let previousIndexPath = NSIndexPath(forRow: indexOfPreviousOption, inSection: 0)
            
            if previousIndexPath.row == indexPath.row
            {
                return
            }
            
            if let previousCell = tableView.cellForRowAtIndexPath(previousIndexPath)
            {
                previousCell.accessoryType = .None
                previousCell.textLabel!.textColor = UIColor.darkTextColor()
            }
        }
        
        // update current cell
        if let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        {
            selectedCell.accessoryType = .Checkmark
            selectedCell.textLabel!.textColor = UIColor.tableItemSelectionColor
        }
        
        settingsItem!.selectedOption = settingsItem!.options[indexPath.row]
    }
}
