//
//  TemplateGroup.swift
//  ModuleGenerator
//
//  Created by Dmitry Savinov on 19.10.2023.
//

import Foundation

// MARK: - TemplateGroup

public enum TemplateGroup: String, Equatable, CaseIterable, Codable {
    
    // MARK: - Cases
    
    case normal = "Default"
    case idRelodable = "IDReloadable"
    case relodable = "Reloadable"
    case pagination = "Paginatable"
}
