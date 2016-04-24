//
//  UIColor+Theme.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 24/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

extension UIColor
{
    class var themeColor: UIColor
    {
        return UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1.0)
    }
    
    class var tableItemSelectionColor: UIColor
    {
        return darkTextColor()
    }
}
