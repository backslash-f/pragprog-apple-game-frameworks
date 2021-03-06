//
//  GameData.swift
//  hog
//
//  Created by Tammy Coron on 10/31/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import Foundation

class GameData: NSObject, Codable {

    // MARK: - Properties

    var wins: Int = 0

    // Set up a shared instance of GameData
    static let shared: GameData = {
        GameData()
    }()

    // MARK: - Lifecycle

    private override init() {}

    // MARK: - Persistence

    func saveDataWithFileName(_ filename: String) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try PropertyListEncoder().encode(self)
            let dataFile = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            try dataFile.write(to: fullPath)
        } catch {
            print("Couldn't write Store Data file.")
        }
    }

    func loadDataWithFileName(_ filename: String) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let contents = try Data(contentsOf: fullPath)
            if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(contents) as? Data {
                let gameData = try PropertyListDecoder().decode(GameData.self, from: data)
                wins = gameData.wins
            }
        } catch {
            print("Couldn't load Store Data file.")
        }
    }

    // MARK: - Helper Methods

    // Get the user's documents directory
    fileprivate func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
