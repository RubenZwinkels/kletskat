//
//  ChatController.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 15/10/2024.
//
import OpenAI
import Foundation

class ChatController: ObservableObject {
    private let env = Env()
    private var apiToken: String
    private var openAi: OpenAI
    
    init(){
        self.apiToken = env.apiToken
        self.openAi = OpenAI(apiToken: apiToken)
    }
}
