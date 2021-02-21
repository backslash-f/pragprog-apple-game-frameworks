//
//  GameKitHelper.swift
//  hog
//
//  Created by Fernando Fernandes on 21.02.21.
//

import GameKit

class GameKitHelper: NSObject {

    // MARK: - Properties

    // Shared GameKit Helper.
    static let shared: GameKitHelper = {
        GameKitHelper()
    }()

    // Game Center & GameKit Related View Controllers.
    var authenticationViewController: UIViewController?

    // MARK: - GameCenter

    func authenticateLocalPlayer() {

        // Prepare for new controller.
        authenticationViewController = nil

        // Authenticate local player.
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // Present the view controller so the player can sign in.
                self.authenticationViewController = viewController
                NotificationCenter.default.post(name: .presentAuthenticationViewController, object: self)
                return
            }

            if error != nil {
                // Player could not be authenticated.
                // Disable Game Center in the game.
                return
            }

            // Player was successfully authenticated.
            // Check if there are any player restrictions before starting the game
            if GKLocalPlayer.local.isUnderage {
                // Hide explicit game content
            }

            if GKLocalPlayer.local.isMultiplayerGamingRestricted {
                // Disable multiplayer game features
            }

            if GKLocalPlayer.local.isPersonalizedCommunicationRestricted {
                // Disable in game communication UI
            }

            // Place the access point on the upper-right corner.
            GKAccessPoint.shared.location = .topLeading
            GKAccessPoint.shared.showHighlights = true
            GKAccessPoint.shared.isActive = true

            // Perform any other configurations as needed...
        }
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    static let presentAuthenticationViewController = Notification.Name("presentAuthenticationViewController")
}
