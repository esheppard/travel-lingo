//
//  UISplitViewController+Utils.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 25/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

extension UISplitViewController
{
    func toggleMasterView()
    {
        let barButtonItem = self.displayModeButtonItem()
        UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
    }
}
