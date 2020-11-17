//
//  GloopDropApp+Logging.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 22.09.20.
//

import AppLogger

enum LoggingCategories: String {
    case collision          = "GloopDrop_Collision"
    case error              = "GloopDrop_Error"
    case inputController    = "GloopDrop_InputController"
    case inputTouch         = "GloopDrop_InputTouch"
    case player             = "GloopDrop_Player"
    case scene              = "GloopDrop_Scene"
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
