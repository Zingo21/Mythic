//
//  MythicApp.swift
//  Mythic
//
//  Created by Esiayo Alegbe on 9/9/2023.
//

// MARK: - Copyright
// Copyright © 2023 blackxfiied, Jecta

// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

import SwiftUI
import Sparkle
import UserNotifications

// MARK: - Where it all begins!
@main
struct MythicApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // MARK: - State Properties
    @AppStorage("isOnboardingPresented") var isOnboardingPresented: Bool = true
    @State var onboardingChapter: OnboardingR2.Phase = .allCases.first!
    @StateObject var networkMonitor = NetworkMonitor()
    @State private var showNetworkAlert = false
    @State private var isInstallViewPresented: Bool = false
    @State private var isAlertPresented: Bool = false
    @State private var isNotificationPermissionsGranted = false
    @State private var bootError: Error?
    
    @State private var activeAlert: ActiveAlert = .updatePrompt
    enum ActiveAlert {
        case updatePrompt, bootError, offlineAlert
    }
    
    // MARK: - Updater Controller
    private let updaterController: SPUStandardUpdaterController
    
    // MARK: - Initialization
    init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }
    
    func toggleTitleBar(_ value: Bool) {
        if let window = NSApp.windows.first {
            window.titlebarAppearsTransparent = !value
            window.isMovableByWindowBackground = !value
            window.titleVisibility = value ? .visible : .hidden
            window.standardWindowButton(.miniaturizeButton)?.isHidden = !value
            window.standardWindowButton(.zoomButton)?.isHidden = !value
        }
    }
    
    // MARK: - App Body
    var body: some Scene {
        Window("Mythic", id: "main") {
            if isOnboardingPresented {
                /*
                OnboardingEvo(fromChapter: onboardingChapter)
                    .transition(.opacity)
                    .frame(minWidth: 750, minHeight: 390)
                 */
                OnboardingR2()
                    .onAppear {
                        toggleTitleBar(false)
                        
                        // Bring to front
                        if let window = NSApp.mainWindow {
                            window.makeKeyAndOrderFront(nil)
                            NSApp.activate(ignoringOtherApps: true)
                        }
                    }
            } else {
                MainView()
                    .transition(.opacity)
                    .environmentObject(networkMonitor)
                    .frame(minWidth: 750, minHeight: 390)
                    .onAppear { toggleTitleBar(true) }
                    .task(priority: .medium) {
                        if let latestVersion = Engine.fetchLatestVersion(),
                           let currentVersion = Engine.version,
                           latestVersion > currentVersion {
                            activeAlert = .updatePrompt
                            isAlertPresented = true // TODO: add to onboarding chapter
                        }
                    }
                    .task(priority: .background) {
                        if Engine.exists, Wine.allBottles?["Default"] == nil {
                            onboardingChapter = .defaultBottleSetup
                            isOnboardingPresented = true
                        }
                    }
                
                // MARK: - Other Properties
                // Reference: https://arc.net/l/quote/cflghpbh
                    .onChange(of: networkMonitor.isEpicAccessible) { _, newValue in
                        if newValue == false {
                            activeAlert = .offlineAlert
                            isAlertPresented = true
                        }
                    }
                
                    .alert(isPresented: $isAlertPresented) {
                        switch activeAlert {
                        case .updatePrompt:
                            Alert(
                                title: Text("Time for an update!"),
                                message: Text("The backend that allows you to play Windows® games on macOS just got an update."),
                                primaryButton: .default(Text("Update")), // TODO: implement
                                secondaryButton: .cancel(Text("Later"))
                            )
                        case .bootError:
                            Alert(
                                title: Text("Unable to boot default bottle."),
                                message: Text("Mythic was unable to create the default Windows® container to launch Windows® games. Please contact support. (Error: \((bootError ?? UnknownError()).localizedDescription))"),
                                dismissButton: .destructive(Text("Quit Mythic")) { NSApp.terminate(nil) }
                            )
                        case .offlineAlert:
                            Alert(
                                title: Text("Can't connect."),
                                message: Text("Mythic is unable to connect to the internet. App functionality will be limited.")
                            )
                        }
                    }
            }
        }
        
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Check for Updates...", action: updaterController.updater.checkForUpdates)
                    .disabled(!updaterController.updater.canCheckForUpdates)
                
                if !isOnboardingPresented {
                    Button("Restart Onboarding...") {
                        withAnimation(.easeInOut(duration: 2)) {
                            isOnboardingPresented = true
                        }
                    }
                }
            }
        }
        
        // MARK: - Settings View
        Settings {
            UpdaterSettingsView(updater: updaterController.updater)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NetworkMonitor())
}
