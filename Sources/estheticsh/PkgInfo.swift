//
//  pkgInfo.swift
//  
//
//  Created by Michał Kątnik on 11/03/2023.
//


struct PkgInfo {
    
    // General package information.
    static let version = "1.0.0"
    static let name = "esteticsh"
    static let author = "Michał Kątnik (github.com/rideee)"
    static let repository = "https://github.com/rideee/estheticsh"
    
    static var description: String {
    """
    Make your terminal output more aesthetic with \(name), by adding colorful output and some \
    other useful decorations. You can easily use it in your shell scripts to make your scripts \
    beauty.
    """
    }
      
    static var fullDescription: String {
        """
        INFO:
            Name: \(name)
            Version: \(version)
            Author: \(author)
            Repository: \(repository)
        """
    }

}
