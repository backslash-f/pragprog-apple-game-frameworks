//
//  GameControllerOverseer.swift
//  gloop-drop iOS
//
//  Created by Fernando Fernandes on 12.10.20.
//

import Foundation
import GameController
import Combine

/// Observes MFI or Remote Controllers in the area. Sets them up.
class GameControllerOverseer: ObservableObject {

    // MARK: - Properties

    var objectWillChange = PassthroughSubject<GameControllerOverseer, Never>()

    #warning("FIXME: Change to Publisher")
    var isGameControllerConnected = false

    // MARK: - Private Properties

    private var cancellableNotifications = Set<AnyCancellable>()

    private let notificationCenter = NotificationCenter.default

    // MARK: - Lifecycle

    init() {
        listenToGameControllerNotifications()
    }
}

// MARK: - Private

private extension GameControllerOverseer {

    #warning("TODO: add joystick support")
    // https://medium.com/@samdubois18/adding-controller-support-to-your-ios-app-a9b8308ce0b4
    #warning("TODO: test all platform")

    // MARK: - GCController

    func listenToGameControllerNotifications() {
        listenToGCControllerDidConnect()
        listenToGCControllerDidDisconnect()
    }

    // MARK: Connect

    func listenToGCControllerDidConnect() {
        notificationCenter
            .publisher(for: NSNotification.Name.GCControllerDidConnect)
            .sink(receiveValue: { [weak self] notification in
                #warning("FIXME: User assign(to:...) instead")
                // See https://stackoverflow.com/a/57933796/584548
                self?.handle(controllerNotification: notification, isConnected: true)
            })
            .store(in: &cancellableNotifications)
    }

    // MARK: Disconnect

    func listenToGCControllerDidDisconnect() {
        notificationCenter
            .publisher(for: NSNotification.Name.GCControllerDidDisconnect)
            .sink(receiveValue: { [weak self] notification in
                #warning("FIXME: User assign(to:...) instead")
                // See https://stackoverflow.com/a/57933796/584548
                self?.handle(controllerNotification: notification, isConnected: false)
            })
            .store(in: &cancellableNotifications)
    }

    // MARK: Notification Handling

    /// Handles `GCController`'s notifications, updates `GameControllerOverseer.getter:isGameControllerConnected`
    /// according to the given `isConnected` and publishes the changes via `GameControllerOverseer.getter:objectWillChange`.
    func handle(controllerNotification: Notification, isConnected: Bool) {
        GloopDropApp.log("Receive notification: \(controllerNotification)", category: .gameController)
        #warning("FIXME: User .receive(on...) instead")
        self.isGameControllerConnected = isConnected
        self.objectWillChange.send(self)
    }
}
