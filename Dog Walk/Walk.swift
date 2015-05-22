//
//  Walk.swift
//  Dog Walk
//
//  Created by Aaron Bradley on 5/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation
import CoreData

class Walk: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var dog: NSManagedObject

}
