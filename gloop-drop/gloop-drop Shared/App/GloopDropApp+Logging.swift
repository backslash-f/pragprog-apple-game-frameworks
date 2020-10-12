//
//  GloopDropApp+Logging.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 22.09.20.
//

import AppLogger

enum LoggingCategories: String {
    case error = "Error"
    case gameController = "GameController"
    case spriteKit = "SpriteKit"
}

extension GloopDropApp {

    static func log(_ information: String, category: LoggingCategories) {
        let logger = AppLogger(
            subsystem: AppLogger.Defaults.subsystem,
            category: category.rawValue
        )
        logger.log(information)
    }

    static func logError(_ error: String) {
        let logger = AppLogger(
            subsystem: AppLogger.Defaults.subsystem,
            category: LoggingCategories.error.rawValue
        )
        logger.log(error)
    }
}
