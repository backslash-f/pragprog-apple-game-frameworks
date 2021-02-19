//
//  ValsRevenge+Logging.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 08.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import AppLogger

enum LoggingCategories: String {
    case error              = "ValsRevenge_Error"
    case inputController    = "ValsRevenge_InputController"
    case inputTouch         = "ValsRevenge_InputTouch"
    case orientation        = "ValsRevenge_Orientation"
    case persistence        = "ValsRevenge_Persistence"
    case player             = "ValsRevenge_Player"
    case scene              = "ValsRevenge_Scene"
    case state              = "ValsRevenge_State"
}

extension ValsRevenge {

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
