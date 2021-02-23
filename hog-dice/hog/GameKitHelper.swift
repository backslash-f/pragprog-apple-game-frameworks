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

    var gameCenterViewController: GKGameCenterViewController?

    // Leaderboard IDs.
    static let leaderBoardIDMostWins = "com.backslashf.hogdice.leaderboards.mostwins"

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

    // Report Score
    func reportScore(score: Int, forLeaderboardID leaderboardID: String, errorHandler: ((Error?)->Void)? = nil) {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        GKLeaderboard.submitScore(
            score,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [leaderboardID],
            completionHandler: errorHandler ?? { error in
                print("error: \(String(describing: error))")
            }
        )
    }

    // Report Achievement
    func reportAchievements(achievements: [GKAchievement], errorHandler: ((Error?)->Void)? = nil) {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        GKAchievement.report(achievements, withCompletionHandler: errorHandler)
    }
}

// MARK: - Achievements

class AchievementsHelper {
    static let achievementIdFirstWin = "com.backslashf.hogdice.achievements.firstwin"

    class func firstWinAchievement(didWin: Bool) -> GKAchievement {
        let achievement = GKAchievement(identifier: AchievementsHelper.achievementIdFirstWin)

        if didWin {
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
        }
        return achievement
    }
}

// MARK: - GKGameCenterControllerDelegate

extension GameKitHelper: GKGameCenterControllerDelegate {
    
    // Show the Game Center View Controller.
    func showGKGameCenter(state: GKGameCenterViewControllerState) {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }

        // Prepare for new controller.
        gameCenterViewController = nil

        // Create the instance of the controller.
        gameCenterViewController = GKGameCenterViewController(state: state)

        // Set the delegate.
        gameCenterViewController?.gameCenterDelegate = self

        // Post the notification.
        NotificationCenter.default.post(name: .presentGameCenterViewController, object: self)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    static let presentAuthenticationViewController = Notification.Name("presentAuthenticationViewController")
    static let presentGameCenterViewController = Notification.Name("presentGameCenterViewController")
}
