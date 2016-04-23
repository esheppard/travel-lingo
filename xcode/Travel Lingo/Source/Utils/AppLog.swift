//
//  AppLog.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 20/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import UIKit

enum LogLevel: String {
    case Message, Warning, Error
}

enum LogUserStatus {
    case Silent, AlertUser
}


func AppLog(level: LogLevel, _ userStatus: LogUserStatus = .Silent, _ format: String, _ args: CVarArgType...)
{
    let msg = String(format: format, arguments: args)
    print("\(level), \(msg)")
    
    if userStatus == .AlertUser {
        displayMessage(msg)
    }
}

private func displayMessage(msg: String)
{
    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
    
    let closeAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                    style: UIAlertActionStyle.Default,
                                    handler: nil)
    
    alert.addAction(closeAction)
    
    if let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}
