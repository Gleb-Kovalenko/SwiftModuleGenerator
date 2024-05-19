//
//  MainItemReducer.swift
//  TCATemplate
//
//  Created by Dmitry Savinov on 19.10.2023.
//  Copyright © 2023 Incetro Inc. All rights reserved.
//

import ComposableArchitecture

// MARK: - MainItemReducer

public struct MainItemReducer: Reducer {
    
    // MARK: - Feature
    
    public var body: some Reducer<MainItemState, MainItemAction> {
        Reduce { state, action in
            switch action {
            case .onTap:
                state.isSelected.toggle()
            default:
                break
            }
            return .none
        }
    }
}
