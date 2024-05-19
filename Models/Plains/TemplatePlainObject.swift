//
//  TemplatePlainObject.swift
//  ModuleGenerator
//
//  Created by Dmitry Savinov on 23.10.2023.
//

import Foundation

// MARK: - TemplatePlainObject

public struct TemplatePlainObject: Equatable, Codable {
    
    // MARK: - Properties
    
    public let templateGroup: TemplateGroup
    public let templateName: String
    public let templatePath: URL
    
    // MARK: - Initializers
    
    public init(
        templateName: String,
        templatePath: URL
    ) {
        self.templateName = templateName
        self.templatePath = templatePath
        templateGroup = TemplateGroup.allCases.filter {
            guard $0 != .normal else { return false }
            return templateName.lowercased().contains($0.rawValue.lowercased())
        }.first ?? .normal
    }
}
