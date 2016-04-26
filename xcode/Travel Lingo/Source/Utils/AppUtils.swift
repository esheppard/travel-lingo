//
//  AppUtils.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 26/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

func isPad() -> Bool
{
    return UI_USER_INTERFACE_IDIOM() == .Pad
}

func isPortrait() -> Bool
{
    return UIApplication.sharedApplication().statusBarOrientation == .Portrait
}
