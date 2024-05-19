//
//  MainItemView.swift
//  TCATemplate
//
//  Created by Dmitry Savinov on 19.10.2023.
//  Copyright © 2023 Incetro Inc. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

// MARK: - MainItemView

public struct MainItemView: View {
    
    // MARK: - Properties
    
    /// The store powering the `MainItem` reducer
    public let store: StoreOf<MainItemReducer>
    
    // MARK: - View
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Text(viewStore.templateName)
                    .font(.title3)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
            }
            .frame(height: 34)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .fill(viewStore.isSelected ? Color.green : Color.white)
            )
            .padding(18)
            .animation(.easeInOut(duration: 0.2), value: viewStore.isSelected)
            .onTapGesture {
                viewStore.send(.onTap)
            }
        }
    }
}
