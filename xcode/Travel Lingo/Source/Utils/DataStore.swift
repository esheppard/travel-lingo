//
//  DataStore.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 20/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation


private let _DataStoreInstance = DataStore()

class DataStore
{
    private var store = [String: AnyObject]()

    class var sharedStore: DataStore
    {
        return _DataStoreInstance
    }

    
    func setObject(object: AnyObject?, forKey key: String)
    {
        if let obj = object
        {
            store[key] = obj
        }
        else
        {
            store.removeValueForKey(key)
        }
    }
        
    func objectForKey(key: String) -> AnyObject?
    {
        return store[key]
    }
}
