//
//  String+Utils.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 22/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

extension String
{
    var lastPathComponent: String
    {
        return (self as NSString).lastPathComponent
    }
    
    var stringByDeletingPathExtension: String
    {
        return (self as NSString).stringByDeletingPathExtension
    }
    
    var pathExtension: String
    {
        return (self as NSString).pathExtension
    }
}
