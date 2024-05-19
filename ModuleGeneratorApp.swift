//
//  ModuleGeneratorApp.swift
//  ModuleGenerator
//
//  Created by Dmitry Savinov on 19.10.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct ModuleGeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            MainListView(
                store: Store(
                    initialState: MainListState(),
                    reducer: { MainListReducer(
                        moduleGeneratorService: ModuleGeneratorServiceImplementation()
                    )
                    }
                )
            )
        }
    }
}
