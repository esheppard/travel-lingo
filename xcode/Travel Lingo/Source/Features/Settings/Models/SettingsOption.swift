//
//  SettingsOption.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 23/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

class SettingsOption: Equatable
{
    let key: String

    let title: String
    let image: UIImage?
    
    
    init(key: String, title: String, image: UIImage? = nil)
    {
        self.key = key
        self.title = title
        self.image = image
    }
}

func == (lhs: SettingsOption, rhs: SettingsOption) -> Bool
{
    return lhs.key == rhs.key
}
