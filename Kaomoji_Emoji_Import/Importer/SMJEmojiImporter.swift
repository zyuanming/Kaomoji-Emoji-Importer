//
//  SMJEmojiImporter.swift
//  Importer
//
//  Created by Zhang Yuanming on 7/25/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation
import CoreData

class SMJEmojiImporter: SMJFileImporter {
    override func entityName() -> String {
        return SMJEmojiSearchModel.entityName()
    }
    
    override func importContent(line: String, intoContext context: NSManagedObjectContext) -> NSManagedObject? {
        let fields = line.components(separatedBy: " ,,,")
        if fields.count == 3 {
            if let insertIndex = Int32(fields[0].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)) {
                let object: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName(), into: managedObjectContext)
                if let emoji = object as? SMJEmojiSearchModel {
                    emoji.index = insertIndex
                    emoji.name = fields[1].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                    emoji.emoji = fields[2].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                    
                    return emoji
                }
            }
        }
        
        return nil
    }
    
    private func getCurrentSavedIndex() -> Int32 {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: SMJEmojiSearchModel.entityName())
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        do {
            let emoji = try managedObjectContext.fetch(request).first
            if let _emoji = emoji as? SMJEmojiSearchModel {
                return _emoji.index
            }
            
            return 0
        } catch {
            let nserror = error as NSError
            print("[Search Emoji] error \(nserror), \(nserror.userInfo)")
            
            return 0
        }
    }
}
