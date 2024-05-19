//
//  MainListAction.swift
//  TCATemplate
//
//  Created by Dmitry Savinov on 19.10.2023.
//  Copyright © 2023 Incetro Inc. All rights reserved.
//

import Foundation
import TCANetworkReducers

// MARK: - MainListAction

public enum MainListAction: Equatable {
    
    // MARK: - Cases
    
    /// General action that calls when view appears
    case onAppear
    
    /// General action that calls when view disappears
    case onDisappear
    
    /// Generates module from selected template
    case generateModule
    
    // MARK: - Binding
    
    case setModuleName(String)
    case setOutputPath(String)
    
    // MARK: - Children
    
    /// Child action for `MainItem` module.
    ///
    /// It's necessary as we use `ForEach` scope operator in current module's reducer.
    /// In short, the `mainItem` case means that every action in `MainItem` module
    /// will be sent to current module with target element identifier
    case mainItem(id: MainItemState.ID, action: MainItemAction)
    
    case alertDimissed
    
    // MARK: - Reloadable
    
    case reloadableMainList(ReloadableAction<[TemplatePlainObject], ModuleGeneratorServiceError>)
    
    // MARK: - Service
    
    case moduleGenerationService(Result<ModuleGeneratorServiceAction, ModuleGeneratorServiceError>)
}
