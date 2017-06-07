//
//  SMJEmojiSearchModel.swift
//  Importer
//
//  Created by Zhang Yuanming on 6/14/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation
import CoreData

class SMJEmojiSearchModel: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var emoji: String
    @NSManaged var index: Int32
    var contentWidth: CGFloat = 0.0
    
    class func entityName() -> String {
        return "SMJEmojiSearchModel"
    }
}
