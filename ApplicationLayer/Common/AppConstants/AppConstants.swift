//
//  AppConstants.swift
//  ModuleGenerator
//
//  Created by Dmitry Savinov on 20.10.2023.
//

import Foundation

// MARK: - AppConstants

public enum AppConstants {
    
    // MARK: - Network
    
    public enum Network {
        public static let apiURL = URL(string: "https://github.com/Incetro").unsafelyUnwrapped
    }
    
    // MARK: - Resources
    
    public enum Resources {
        public static let templatesGitURL = Network.apiURL.appendingPathComponent("tca-templates")
    }
    
    // MARK: - Static
    
    public static let templateRenameKey = "TemplateModule"
    
    // MARK: - Defaults
    
    public enum Defaults: String {
        case outputPath = "com.incetro.module-generator.output-path"
    }
}
