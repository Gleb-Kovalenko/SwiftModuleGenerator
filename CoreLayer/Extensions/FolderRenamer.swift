//
//  Folder.swift
//  Veronica
//
//  Created by Дмитрий Савинов on 20.10.2020.
//
import Files

extension Folder {
    
    /// Renaming all flles and folders names, also refactoring content inside each file
    /// - Parameter replacement: dictionary of words that needs to be changed with another options
    /// - Throws: `LocationError` if the item couldn't be renamed.
   public func renameAll(with replacement: [String: String]) throws {
        try rename(to: name.replacingOccurrences(with: replacement))
        try renameFiles(with: replacement)
        try subfolders.recursive.forEach { folder in
            try folder.rename(to: folder.name.replacingOccurrences(with: replacement))
            try folder.renameFiles(with: replacement)
        }
    }

    /// Renaming all flles names, also refactoring content inside each file (without subfolders and their files)
    /// - Parameter replacement: dictionary of words that needs to be changed with another options
    /// - Throws: `LocationError` if the item couldn't be renamed.
    public func renameFiles(with replacement: [String: String]) throws {
        try files.enumerated().forEach { (index, file) in
            try file.rename(to: file.name.replacingOccurrences(with: replacement))
            file.refactorContent(with: replacement)
        }
    }
}
