//
//  ViewController.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/10/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
  var currentDog: Dog!
  var managedContext: NSManagedObjectContext!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    tableView.registerClass(UITableViewCell.self,
      forCellReuseIdentifier: "Cell")

    let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: managedContext)
    let dogName = "Snoopy"
    let dogFetch = NSFetchRequest(entityName: "Dog")
    dogFetch.predicate = NSPredicate(format: "name == %@", dogName)

    var error: NSError?
    let result = managedContext.executeFetchRequest(dogFetch, error: &error) as! [Dog]?

    if let dogs = result {
      if dogs.count == 0 {
        currentDog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
        currentDog.name = dogName

        if !managedContext.save(&error) {
          println("Could not save: \(error)")
        }
      } else {
        currentDog = dogs[0]
      }
    } else {
      println("Could not fetch: \(error)")
    }
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    
      return currentDog.walks.count
  }
  
  func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
      return "List of Walks";
  }

  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      let walkToRemove = currentDog.walks[indexPath.row] as! Walk
      managedContext.deleteObject(walkToRemove)
      var error: NSError?

      if !managedContext.save(&error) {
        println("Could not save: \(error)")
      }

      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell =
      tableView.dequeueReusableCellWithIdentifier("Cell",
      forIndexPath: indexPath) as! UITableViewCell
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = .ShortStyle
    dateFormatter.timeStyle = .MediumStyle
    
    let walk = currentDog.walks[indexPath.row] as! Walk
    cell.textLabel?.text = dateFormatter.stringFromDate(walk.date)
    
    return cell
  }
  
  @IBAction func add(sender: AnyObject) {
    // add new Walk entity into Core Data
    let walkEntity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: managedContext)
    let walk = Walk(entity: walkEntity!, insertIntoManagedObjectContext: managedContext)
    walk.date = NSDate()

    // add the new Walk into the Dog's walks set
    var walks = currentDog.walks.mutableCopy() as! NSMutableOrderedSet
    walks.addObject(walk)

    currentDog.walks = walks.copy() as! NSOrderedSet

    // save the managed object context
    var error: NSError?

    if !managedContext!.save(&error) {
      println("Could not save: \(error)")
    }

    //reload them joints
    tableView.reloadData()
  }
  
}

