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

    @Published var isGameControllerConnected: Bool = false

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

    // MARK: - GCController

    func listenToGameControllerNotifications() {
        setupSubscription(for: .GCControllerDidConnect)
        setupSubscription(for: .GCControllerDidDisconnect)
    }

    // MARK: Subscription Setup

    func setupSubscription(for notificationName: Notification.Name) {
        let didConnect = (notificationName == .GCControllerDidConnect)
        notificationCenter
            .publisher(for: notificationName)
            .handleEvents(receiveOutput: { self.log($0) })
            .receive(on: DispatchQueue.main)
            .map({ _ in didConnect })
            .assign(to: \.isGameControllerConnected, on: self)
            .store(in: &cancellableNotifications)
    }

    // MARK: Logging

    func log(_ controllerNotification: Notification) {
        GloopDropApp.log("Receive notification: \(controllerNotification)", category: .gameController)
    }
}
