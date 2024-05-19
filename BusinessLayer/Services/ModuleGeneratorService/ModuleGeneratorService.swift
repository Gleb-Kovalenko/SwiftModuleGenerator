//
//  ModuleGeneratorService.swift
//  ModuleGenerator
//
//  Created by Dmitry Savinov on 20.10.2023.
//

import Foundation
import ServiceCore

// MARK: - ModuleGeneratorServiceAction

public enum ModuleGeneratorServiceAction: Equatable {
    
    // MARK: - Cases
    
    case templatesGitCloned([TemplatePlainObject])
    case moduleGenerationCompleted(Bool)
}

// MARK: - ModuleGeneratorServiceError

public typealias ModuleGeneratorServiceError = NSError

// MARK: - ModuleGeneratorService

public protocol ModuleGeneratorService {
    
    func cloneTemplatesRepositoryInAppDirectory() -> ServiceCall<[TemplatePlainObject]>
    func obtainCachedTemplates() -> ServiceCall<[TemplatePlainObject]?>
    func generateModule(templatePath: String, outputPath: String, moduleName: String) -> ServiceCall<Bool>
}
