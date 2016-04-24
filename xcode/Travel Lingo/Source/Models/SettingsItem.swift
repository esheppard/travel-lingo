//
//  SettingsItem.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 23/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

typealias SelectionChanged = (selected: SettingsOption?) -> Void


class SettingsItem
{
    let title: String
    var options = [SettingsOption]()
    
    var selectionChanged: SelectionChanged?
    private var executingSelectionDidChange: Bool = false
    
    var selectedOption: SettingsOption?
    {
        didSet
        {
            if let option = selectedOption
            {
                if !options.contains(option)
                {
                    AppLog("Unable to set setting item's selected option: the selected option is not contained in the options array")
                    
                    selectedOption = nil
                    return
                }
            }
            
            if !executingSelectionDidChange
            {
                executingSelectionDidChange = true
                self.selectionChanged?(selected: selectedOption)
                executingSelectionDidChange = false
            }
        }
    }
    
    
    init(title: String)
    {
        self.title = title
    }
    
    
    func optionMatchingKey(key: String) -> SettingsOption?
    {
        if options.count == 0 {
            return nil
        }
        
        for option in options
        {
            if option.key == key {
                return option
            }
        }
        
        return nil;
    }
}
