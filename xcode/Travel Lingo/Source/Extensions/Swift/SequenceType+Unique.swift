//
//  SequenceType+Unique.swift
//  Travel Lingo
//
//  Created by Elijah Sheppard on 20/04/2016.
//  Copyright © 2016 Elijah Sheppard. All rights reserved.
//

import Foundation

extension SequenceType where Generator.Element: Hashable
{
    var uniqueElements: [Generator.Element]
    {
        return Array( Set(self) )
    }
}

extension SequenceType where Generator.Element: Equatable
{
    var uniqueElements: [Generator.Element]
    {
        return reduce([])
        {
            uniqueElements, element in
            uniqueElements.contains(element) ? uniqueElements : uniqueElements + [element]
        }
    }
}
