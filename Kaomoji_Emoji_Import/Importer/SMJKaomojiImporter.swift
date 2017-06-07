//
//  SMJKaomojiImporter.swift
//  Importer
//
//  Created by Zhang Yuanming on 7/25/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation
import CoreData

class SMJKaomojiImporter: SMJFileImporter {
    override func entityName() -> String {
        return SMJKaomojiSearchModel.entityName()
    }
    
    override func importContent(line: String, intoContext context: NSManagedObjectContext) -> NSManagedObject? {
        let fields = line.components(separatedBy: " ,,,")
        if fields.count == 3 {
            if let insertIndex = Int32(fields[0].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)) {
                let object: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName(), into: managedObjectContext)
                if let kaomoji = object as? SMJKaomojiSearchModel {
                    kaomoji.index = insertIndex
                    kaomoji.name = fields[1].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                    kaomoji.kaomoji = fields[2].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                    
                    return kaomoji
                }
            }
        }
        
        return nil
    }
    
    private func getCurrentSavedIndex() -> Int32 {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: SMJKaomojiSearchModel.entityName())
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        do {
            let kaomoji = try managedObjectContext.fetch(request).first
            if let _kaomoji = kaomoji as? SMJKaomojiSearchModel {
                return _kaomoji.index
            }
            
            return 0
        } catch {
            let nserror = error as NSError
            print("[Search Emoji] error \(nserror), \(nserror.userInfo)")
            
            return 0
        }
    }
}
