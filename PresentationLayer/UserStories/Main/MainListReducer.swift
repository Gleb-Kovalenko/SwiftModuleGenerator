//
//  MainListReducer.swift
//  TCATemplate
//
//  Created by Dmitry Savinov on 19.10.2023.
//  Copyright © 2023 Incetro Inc. All rights reserved.
//

import ComposableArchitecture
import TCANetworkReducers
import Combine
import Foundation

// MARK: - MainListReducer

public struct MainListReducer: Reducer {
    
    // MARK: - Properties
    
    /// ModuleGeneratorService instance
    public let moduleGeneratorService: ModuleGeneratorService
    
    // MARK: - Feature
    
    public var body: some Reducer<MainListState, MainListAction> {
        Scope(state: \.reloadableMainList, action: /MainListAction.reloadableMainList) {
            RelodableReducer(
                obtain: {
                    moduleGeneratorService
                        .cloneTemplatesRepositoryInAppDirectory()
                        .publish()
                },
                cache: {
                    moduleGeneratorService
                        .obtainCachedTemplates()
                        .publish()
                }
            )
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.outputPath = UserDefaults.standard.string(
                    forKey: AppConstants.Defaults.outputPath.rawValue
                ) ?? ""
                return .send(.reloadableMainList(.load))
            case .reloadableMainList(.response(.success(let data))),
                    .reloadableMainList(.cacheResponse(.success(.some(let data)))):
                state.mainItems = IdentifiedArray(uniqueElements: data.map(MainItemState.init))
            case .reloadableMainList(.response(.failure(let error))),
                 .reloadableMainList(.cacheResponse(.failure(let error))):
                state.alert = AlertState(
                    title: TextState("Something wen't wrong"),
                    message: TextState(error.localizedDescription)
                )
            case .mainItem(id: let id, action: .onTap):
                state.mainItems.ids.forEach { itemId in
                    guard id != itemId else { return }
                    state.mainItems[id: itemId]?.isSelected = false
                }
            case .setModuleName(let moduleName):
                state.moduleName = moduleName.capitalizedFirstLetter
            case .setOutputPath(let path):
                state.outputPath = path
                UserDefaults.standard.set(
                    path,
                    forKey: AppConstants.Defaults.outputPath.rawValue
                )
            case .generateModule:
                guard
                    let templatePath = state.templatePath,
                    !state.moduleName.isEmpty,
                    !state.outputPath.isEmpty
                else {
                    state.alert = AlertState(
                        title: TextState("Incorrect input"),
                        message: TextState("Give outpat path, module name and select template from the list")
                    )
                    return .none
                }
                return moduleGeneratorService
                    .generateModule(
                        templatePath: templatePath,
                        outputPath: state.outputPath,
                        moduleName: state.moduleName
                    )
                    .publish()
                    .map(ModuleGeneratorServiceAction.moduleGenerationCompleted)
                    .catchToEffect(MainListAction.moduleGenerationService)
            case .alertDimissed:
                state.alert = nil
            default:
                break
            }
            return .none
        }
        .forEach(\.mainItems, action: /MainListAction.mainItem(id:action:)) {
            MainItemReducer()
        }
    }
}
