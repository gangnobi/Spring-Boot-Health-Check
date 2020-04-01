//
//  ContentView.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 28/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import AppKit
import LaunchAtLogin
import SwiftUI

struct LaunchAtLoginFlag {
    var val: Bool = true {
        didSet {
            LaunchAtLogin.isEnabled = val
        }
    }
}

struct ContentView: View {
    @State var showServiceCollectionView: Bool = true
    @State var currentCollection: [ServiceDetailViewModel] = []
    @State var currentCollectionName: String = ""
    @State var isLaunchAtLoginFlag = LaunchAtLoginFlag()

    var body: some View {
        VStack {
            if self.showServiceCollectionView {
                ServiceCollectionManagementView(
                    currentCollection: self.$currentCollection, currentCollectionName: self.$currentCollectionName, showServiceCollection: self.$showServiceCollectionView
                )
            } else {
                ServiceCollectionView(
                    showServiceCollection: self.$showServiceCollectionView,
                    modelData: self.currentCollection, modelDataName: self.currentCollectionName
                )
            }

            HStack(spacing: 0) {
                Toggle(isOn: self.$isLaunchAtLoginFlag.val) {
                    Text("Launch at login")
                }
                .padding(.leading, 10)
                Spacer()
                //                Button(action: {}) {
                //                    Image("settings").foregroundColor(Color.primary.opacity(0.6))
                //                }
                //                .padding(7)
                //                .buttonStyle(PlainButtonStyle())
                Button(action: {
                    NSApplication.shared.terminate(self)
                                }) {
                    Image("turn-off").foregroundColor(Color.primary.opacity(0.6))
                }
                .padding(7)
                .buttonStyle(PlainButtonStyle())
            }.background(Color.primary.colorInvert().opacity(0.2))
        }.onAppear {
            self.isLaunchAtLoginFlag.val = LaunchAtLogin.isEnabled
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
