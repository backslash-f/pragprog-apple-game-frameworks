//
//  GameData.swift
//  valsrevenge
//
//  Created by Tammy Coron on 7/4/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import Foundation

class GameData: NSObject, Codable {

    // MARK: - Properties

    var level: Int = 1
    var keys: Int = 0
    var treasure: Int = 0

    // Set up a shared instance of GameData.
    static let shared: GameData = {
        GameData()
    }()

    // MARK: - Lifecycle

    private override init() {}

    // MARK: - Save & Load Locally Stored Game Data.

    func saveDataWithFileName(_ filename: String) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try PropertyListEncoder().encode(self)
            let dataFile = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            try dataFile.write(to: fullPath)
        } catch {
            ValsRevenge.log("Couldn't write Store Data file.", category: .persistence)
        }
    }

    func loadDataWithFileName(_ filename: String) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let contents = try Data(contentsOf: fullPath)
            if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(contents) as? Data {
                let gameData = try PropertyListDecoder().decode(GameData.self, from: data)

                // Restore data (properties).
                level = gameData.level
                keys = gameData.keys
                treasure = gameData.treasure
            }
        } catch {
            ValsRevenge.log("Couldn't load Store Data file.", category: .persistence)
        }
    }

    /// Get the user's documents directory.
    fileprivate func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
