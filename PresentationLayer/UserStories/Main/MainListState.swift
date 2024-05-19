//
//  MainListState.swift
//  TCATemplate
//
//  Created by Dmitry Savinov on 19.10.2023.
//  Copyright © 2023 Incetro Inc. All rights reserved.
//

import Foundation
import ComposableArchitecture
import TCANetworkReducers

// MARK: - MainListState

public struct MainListState: Equatable {
    
    // MARK: - Properties
    
    /// Path for target template
    public var templatePath: String? {
        mainItems.filter(\.isSelected).first?.path
    }
    
    /// Path for generated module
    public var outputPath = ""
    
    /// Target module name for generation
    public var moduleName = ""
    
    // MARK: - Children
    
    /// Identified array of `MainItemState`
    ///
    /// It's represents children of `MainItemState` module.
    /// We use it here to integrate `MainItemState` array logic inside current module.
    /// If you change the state inside one of the `MainItemState` module items then all changes will be saved here.
    public var mainItems: IdentifiedArrayOf<MainItemState>
    
    /// Alert instance
    public var alert: AlertState<MainListAction>?
    
    // MARK: - Relodable
    
    /// ReloadableState instace for network operations
    public var reloadableMainList: ReloadableState<[TemplatePlainObject], ModuleGeneratorServiceError>
}

// MARK: - Initializers

extension MainListState {
    
    /// Default initializer
    public init() {
        self.reloadableMainList = ReloadableState()
        self.mainItems = []
    }
}
