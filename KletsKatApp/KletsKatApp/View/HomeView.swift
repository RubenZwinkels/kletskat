//
//  HomeView.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 28/09/2024.
//
import Foundation
import SwiftUI

struct HomeView: View{
    @ObservedObject var catController = CatController.shared
    
    var body: some View{
        ZStack{
            Color.background.ignoresSafeArea() //achtergrond
            VStack{
                Text("dummy text").padding(.top, 100)
                CatView(catColor: catController.catModel.color)
            }
        }
    }
    
}

#Preview {
    HomeView()
}
