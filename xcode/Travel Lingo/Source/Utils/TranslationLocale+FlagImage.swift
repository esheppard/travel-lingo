//
//  TranslationLocale+Image.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 22/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

extension TranslationLocale
{
    var flagImage: UIImage?
    {
        return UIImage(named: countryCodeForFlag.uppercaseString)
    }
}
