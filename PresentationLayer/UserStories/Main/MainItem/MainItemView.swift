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
            HStack {
                Spacer()
                Text(viewStore.templateName)
                    .font(.title3)
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .fill(viewStore.isSelected ? Color.green : Color.white)
            )
            .padding()
            .animation(.easeInOut(duration: 0.2), value: viewStore.isSelected)
            .onTapGesture {
                viewStore.send(.onTap)
            }
        }
    }
}
