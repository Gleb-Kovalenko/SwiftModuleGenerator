//
//  ModuleGeneratorServiceImplementation.swift
//  ModuleGenerator
//
//  Created by Dmitry Savinov on 20.10.2023.
//

import Foundation
import ServiceCore
import HTTPTransport
import Files
import ShellOut

// MARK: - ModuleGeneratorServiceImplementation

public final class ModuleGeneratorServiceImplementation: WebService {
    
    // MARK: - Properties
    
    private var appDirectory: URL? {
        guard let appName = getApplicationName() else { return nil }
        let appSupportDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
        let appDirectory = appSupportDirectory?.appendingPathComponent(appName)
        return appDirectory
    }
    
    // MARK: - Initializers
    
    public init() {
        super.init(
            baseURL: AppConstants.Network.apiURL,
            transport: HTTPTransport()
        )
    }
    
    // MARK: - Private
    
    private func getApplicationName() -> String? {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let appName = infoDictionary["CFBundleName"] as? String
        else {
            return nil
        }
        return appName
    }
    
    private func cloneGitRepository(repositoryURL: String, destinationPath: URL) throws {
        try shellOut(to: .gitClone(url: URL(string: repositoryURL).unsafelyUnwrapped, to: destinationPath.path()))
    }
    
    private func cloneGitRepositoryInAppDirectory(repositoryURL: String) throws {
        guard let appName = getApplicationName() else { throw NSError(domain: "app", code: 404) }
        let appSupportDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
        guard let appSupportDirectory else { throw NSError(domain: "app", code: 404) }
        let appDirectory = appSupportDirectory.appendingPathComponent(appName)
        if !FileManager.default.fileExists(atPath: appDirectory.path) {
            try FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        try FileManager.default.removeItem(atPath: appDirectory.path())
        try cloneGitRepository(repositoryURL: repositoryURL, destinationPath: appDirectory)
    }
    
    private func obtainTemplates() throws -> [TemplatePlainObject] {
        guard let appDirectory else { throw NSError(domain: "app", code: 404) }
        let templatesFolder = try Folder(path: appDirectory.path())
        let templates = templatesFolder.subfolders.map { templateFolder in
            TemplatePlainObject(
                templateName: templateFolder.name,
                templatePath: templateFolder.url
            )
        }
        return templates
    }
}

// MARK: - ModuleGeneratorService

extension ModuleGeneratorServiceImplementation: ModuleGeneratorService {
  
    public func cloneTemplatesRepositoryInAppDirectory() -> ServiceCall<[TemplatePlainObject]> {
        createCall {
            try self.cloneGitRepositoryInAppDirectory(
                repositoryURL: AppConstants.Resources.templatesGitURL.absoluteString
            )
            let templates = try self.obtainTemplates()
            return .success(templates)
        }
    }
    
    public func obtainCachedTemplates() -> ServiceCall<[TemplatePlainObject]?> {
        createCall {
            let templates = try? self.obtainTemplates()
            return .success(templates)
        }
    }
    
    public func generateModule(templatePath: String, outputPath: String, moduleName: String) -> ServiceCall<Bool> {
        createCall {
            let originFolder = try Folder(path: templatePath)
            let targetFolder = try Folder(path: outputPath)
            let moduleFolder = try originFolder.copy(to: targetFolder)
            try moduleFolder.renameAll(
                with: [
                    originFolder.name: moduleName,
                    AppConstants.templateRenameKey: moduleName,
                    AppConstants.templateRenameKey.lowercasedFirstLetter: moduleName.lowercasedFirstLetter
                ]
            )
            return .success(true)
        }
    }
}
