//
//  String+Extensions.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 09.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

extension String {

    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }
        return String(dropFirst(prefix.count))
    }
}
