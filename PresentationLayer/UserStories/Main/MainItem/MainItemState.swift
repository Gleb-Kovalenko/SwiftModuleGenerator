//
//  MainItemState.swift
//  TCATemplate
//
//  Created by Dmitry Savinov on 19.10.2023.
//  Copyright © 2023 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - MainItemState

public struct MainItemState: Equatable, Identifiable {
    
    // MARK: - Properties
    
    public let id: String
    
    public let templateName: String
    
    public let templateGroup: TemplateGroup
    
    public let path: String
    
    public var isSelected: Bool
}

// MARK: - Initailizers

extension MainItemState {
    
    public init(template: TemplatePlainObject) {
        self.id = template.templateName
        self.templateName = template.templateName
        self.templateGroup = template.templateGroup
        self.path = template.templatePath.path()
        self.isSelected = false
    }
}
