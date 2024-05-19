//
//  MainListView.swift
//  TCATemplate
//
//  Created by Dmitry Savinov on 19.10.2023.
//  Copyright © 2023 Incetro Inc. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import TCANetworkReducers

// MARK: - MainListView

public struct MainListView: View {
    
    // MARK: - Properties
    
    /// The store powering the `MainList` reducer
    public let store: StoreOf<MainListReducer>
    
    /// Columns for list layout
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    // MARK: - View
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.primaryBg.ignoresSafeArea()
                ReloadableView(
                    store: store.scope(
                        state: \.reloadableMainList,
                        action: MainListAction.reloadableMainList
                    ),
                    loader: {
                        ProgressView()
                    }
                ) {
                    Ztack {
                        VStack(spacing: 0) {
                            List {
                                ForEach(TemplateGroup.allCases, id: \.self) { templateGroup in
                                    Section(templateGroup.rawValue) {
                                        LazyVGrid(columns: columns) {
                                            ForEachStore(
                                                store.scope(
                                                    state: { state in
                                                        state.mainItems.filter {
                                                            $0.templateGroup == templateGroup
                                                        }
                                                    },
                                                    action: MainListAction.mainItem(id:action:)
                                                ),
                                                content: MainItemView.init
                                            )
                                        }
                                    }
                                }
                            }
                            Divider()
                            BottomBarView(viewStore: viewStore)
                                .padding(.horizontal, 80)
                                .padding(.vertical, 30)
                                .background(Color.blue.opacity(0.32))
                                .ignoresSafeArea()
                        }
                        .alert(store.scope(state: \.alert), dismiss: .alertDimissed)
                    }
                }
                .disabled(viewStore.reloadableMainList.isLoaderDisplayed)
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .onDisappear {
                    viewStore.send(.onDisappear)
                }
            }
        }
    }
    
    // MARK: - BottomBarView
    
    private struct BottomBarView: View {
        
        // MARK: - Properties
        
        let viewStore: ViewStoreOf<MainListReducer>
        
        // MARK: - View
        
        var body: some View {
            HStack {
                VStack(spacing: 10) {
                    Text("Output path")
                        .font(.system(size: 17, weight: .semibold))
                    TextField(
                        "Provide path",
                        text: viewStore.binding(
                            get: \.outputPath,
                            send: MainListAction.setOutputPath
                        )
                    )
                }
                .frame(width: 300)
                Spacer()
                VStack(spacing: 10) {
                    Text("Module name")
                        .font(.system(size: 17, weight: .semibold))
                    TextField(
                        "Provide name",
                        text: viewStore.binding(
                            get: \.moduleName,
                            send: MainListAction.setModuleName
                        )
                    )
                }
                .frame(width: 300)
                Spacer()
                VStack(spacing: 20) {
                    Button {
                        viewStore.send(.generateModule)
                    } label: {
                        Text("Generate")
                    }
                    Button {
                        viewStore.send(.reloadableMainList(.load))
                    } label: {
                        Text("Update templates from Git")
                    }
                }
            }
        }
    }
}

// MARK: - Preview

private struct MainList_Previews: PreviewProvider {
    
    static var previews: some View {
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
