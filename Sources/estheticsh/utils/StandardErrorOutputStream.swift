//
//  StandardErrorOutputStream.swift
//  
//
//  Created by Michał Kątnik on 11/03/2023.
//

import Foundation


// stderr stream.
class StandardErrorOutputStream: TextOutputStream {
    let stderr = FileHandle.standardError
    
    var appName: String
    var appVersion: String
    var errorMsgHeader: String
    var errorMsgPrefix: String
    var errorMsgFooter: String
    
    init(
        appName: String = "",
        appVersion: String = "",
        errorMsgHeader: String = "",
        errorMsgPrefix: String = "",
        errorMsgFooter: String = ""
    ) {
        self.appName = appName
        self.appVersion = appVersion
        
        // Error message header.
        if errorMsgHeader != "" {
            self.errorMsgHeader = errorMsgHeader
        } else {
            self.errorMsgHeader = ""
            
            if appName != "" {
                self.errorMsgHeader += appName
                
                if appVersion != "" {
                    self.errorMsgHeader += " (v.\(appVersion))"
                }
            }
        }
        
        // Error message prefix.
        if errorMsgPrefix != "" {
            self.errorMsgPrefix = errorMsgPrefix
        } else {
            self.errorMsgPrefix = "ERROR: "
        }
        
        // Error message footer.
        self.errorMsgFooter = errorMsgFooter
    }
    
    // Write msg to stderr.
    func write(_ msg: String) {
        guard let data = msg.data(using: .utf8) else {
            fatalError("StandardErrorOutputStream.write() encoding failure.")
        }
        stderr.write(data)
    }
    
    // Print msg to stderr with a newline at the end.
    func printLn(_ msg: String) {
        self.write("\(msg)\n")
    }
    
    // Print error message.
    func printError(_ msg: String) {
        if self.errorMsgHeader != "" { self.printLn(self.errorMsgHeader) }
        self.printLn(self.errorMsgPrefix + msg)
        if self.errorMsgFooter != "" { self.printLn(self.errorMsgFooter) }
    }
}

