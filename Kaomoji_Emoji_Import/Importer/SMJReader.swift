//
//  SMJReader.swift
//  Importer
//
//  Created by Zhang Yuanming on 7/25/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation

class SMJReader: NSObject {
    var fileURL: URL!
    var totalByteCount: UInt = 0
    var bytesReadCount: Int = 0
    var delimiter: Data = Data(bytes: "\n", count: 1)
    var callBack: ((_ lineNumer: UInt, _ line: String) -> Void)?
    var inputStream: InputStream?
    var remainder: Data?
    var lineNumber: Int = 0
    
    init(fileURL: URL) {
        self.fileURL = fileURL

        do {
            let fileSize = try self.fileURL.resourceValues(forKeys: [URLResourceKey.fileSizeKey]) as AnyObject?
            if let _fileByte = fileSize as? NSNumber {
                self.totalByteCount = _fileByte.uintValue
            }
        } catch {
            print("Get file size error !")
        }
    }
    
    func enumerateLines(withBlock block: @escaping ((_ lineNumer: UInt, _ line: String) -> Void)) {
        self.callBack = block
        
        inputStream = InputStream(url: fileURL)
        inputStream!.open()
        
        readInputStream()
        
        inputStream?.close()
        inputStream = nil
    }
    
    private func readInputStream() {
        guard let _inputStream = inputStream else { return }
        
        while true {
            var buffer:[UInt8] = [UInt8](repeating:0x0,count:4 * 1024)
            let length = _inputStream.read(&buffer, maxLength: buffer.count)
            if length <= 0 {
                break
            }
            bytesReadCount = bytesReadCount + length
            let data = Data(uints: buffer)
            processDataChunk(buffer: data)
        }
        if let _remainder = remainder {
            emitLine(withData: _remainder)
        }
        remainder = nil
    }
    
    private func processDataChunk(buffer: Data) {
        if remainder != nil {
            remainder?.append(buffer)
        } else {
            remainder = Data()
            remainder!.append(buffer)
        }
        remainder?.enumerateComponents(separateBy: delimiter, usingBlock: {[weak self] (component, isLast) in
            guard let strongSelf = self else { return }
            
            if !isLast {
                strongSelf.emitLine(withData: component)
            } else if 0 < component.count {
                var mutData = Data()
                mutData.append(component)
                strongSelf.remainder = mutData
            } else {
                strongSelf.remainder = nil
            }
        })
    }
    
    private func emitLine(withData data: Data) {
        let currentLineNumber = lineNumber
        lineNumber = lineNumber + 1
        if 0 < data.count {
            if let line = String(data: data, encoding: String.Encoding.utf8) {
                self.callBack?(UInt(currentLineNumber), line)
            }
        }
    }
}

