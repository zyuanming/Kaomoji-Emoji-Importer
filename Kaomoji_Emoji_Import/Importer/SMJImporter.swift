//
//  SMJImporter.swift
//  Importer
//
//  Created by Zhang Yuanming on 7/25/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation
import CoreData

class SMJImporter: NSObject {
    var managedObjectContext: NSManagedObjectContext!
    var dataDirectoryURL: URL!
    
    init(persistentStoreURL: URL, managedObjectModel: NSManagedObjectModel, dataURL: URL) {
        super.init()
        dataDirectoryURL = dataURL
        setupCoreDataStack(withStoreURL: persistentStoreURL, objectModel: managedObjectModel)
    }
    
    private func setupCoreDataStack(withStoreURL storeURL: URL, objectModel: NSManagedObjectModel) {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        do {
            let options = [NSSQLitePragmasOption: ["journal_mode": "DELETE"]]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
            managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            
        } catch {
            print("Unable to add store: \(error)")
        }
    }
    
    func startImport() {
        managedObjectContext.performAndWait { [weak self] in
            guard let strongSelf = self else { return }
            
            let emojisURL = strongSelf.dataDirectoryURL.appendingPathComponent("emojis.txt", isDirectory: false)
            if let reachable = try? emojisURL.checkResourceIsReachable(), reachable == true {
                let emojiImporter = SMJEmojiImporter(fileURL: emojisURL, managedObjectContext: strongSelf.managedObjectContext, saveTriggerCount: 250)
                emojiImporter.startImport()
            }
            
            let kaomojisURL = strongSelf.dataDirectoryURL.appendingPathComponent("kaomojis.txt", isDirectory: false)
            if let reachable = try? kaomojisURL.checkResourceIsReachable(), reachable == true {
                let kaomojiImporter = SMJKaomojiImporter(fileURL: kaomojisURL, managedObjectContext: strongSelf.managedObjectContext, saveTriggerCount: 250)
                kaomojiImporter.startImport()
            }
        }
    }
}

