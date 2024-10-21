//
//  WidgetCatView.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 17/10/2024.
//

import SwiftUI

struct WidgetCatView: View {
    var catColor: Color
    var eyeColor: Color
    
    var body: some View {
        Circle()
            .fill(catColor)
            .frame(width: 100, height: 100)
            .overlay(
                Circle()
                    .fill(eyeColor)
                    .frame(width: 20, height: 20)
                    .position(x: 35, y: 35)
            )
            .overlay(
                Circle()
                    .fill(eyeColor)
                    .frame(width: 20, height: 20)
                    .position(x: 65, y: 35)
            )
    }
}
