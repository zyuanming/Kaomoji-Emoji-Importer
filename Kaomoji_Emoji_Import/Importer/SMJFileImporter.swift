//
//  SMJFileImporter.swift
//  Importer
//
//  Created by Zhang Yuanming on 7/25/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation
import CoreData

class SMJFileImporter: NSObject {
    var saveTriggerCount: Int = 0
    var reader: SMJReader!
    var managedObjectContext: NSManagedObjectContext!
    var importCount: Int = 0
    
    init(fileURL: URL, managedObjectContext: NSManagedObjectContext, saveTriggerCount: Int) {
        super.init()
        reader = SMJReader(fileURL: fileURL)
        self.managedObjectContext = managedObjectContext
        self.saveTriggerCount = saveTriggerCount
    }
    
    func startImport() {
        reader.enumerateLines {[weak self] (lineNumer, line) in
            guard let strongSelf = self else { return }
            
            if strongSelf.importContent(line: line, intoContext: strongSelf.managedObjectContext) != nil {
                strongSelf.importCount = strongSelf.importCount + 1
                if (strongSelf.importCount % strongSelf.saveTriggerCount == 0) {
                    strongSelf.saveAndResetContext()
                }
            }
        }
        
        self.saveAndResetContext()
    }
    
    func importContent(line: String, intoContext context: NSManagedObjectContext) -> NSManagedObject? {
        return nil
    }
    
    func entityName() -> String {
        return ""
    }
    
    func saveAndResetContext() {
        saveContext()
        managedObjectContext.reset()
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
            print("save \(importCount) object success !!")
        } catch {
            print("Saving failed: \(error)")
        }
    }
}
