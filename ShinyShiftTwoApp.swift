//
//  ShinyShiftTwoApp.swift
//  ShinyShiftTwo
//
//  Created by Zaidan Akmal on 18/05/25.
//

import SwiftUI
import SwiftData

@main
struct ShinyShiftTwoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Member.self)
    }
}

