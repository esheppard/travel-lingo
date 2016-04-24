//
//  SettingsSection.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 23/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

class SettingsSection
{
    let title: String
    let footer: String?
    
    var items = [SettingsItem]()
    
    
    init(title: String, footer: String? = nil)
    {
        self.title = title
        self.footer = footer
    }
}
