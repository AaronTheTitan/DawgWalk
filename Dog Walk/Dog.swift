//
//  Dog.swift
//  Dog Walk
//
//  Created by Aaron Bradley on 5/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation
import CoreData

class Dog: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var walks: NSOrderedSet

}
