//
//  Constant+Nodes.swift
//  gloop-drop iOS
//
//  Created by Fernando Fernandes on 23.09.20.
//

extension Constant {

    struct Node {

        struct Background {
            static let name = "background"
            static let imageName = "background_1"
        }

        struct Blob {
            static let atlasName = "blob"
            static let name = "Blob Player"
            static let walkTexturePrefix = "blob-walk_"
            static let dieTexturePrefix = "blob-die_"
        }

        struct Collectible {
            static let namePrefix = "co_"
            static let namePrefixRegex = "//\(Constant.Node.Collectible.namePrefix)*"
            static let imageName = "gloop"
        }

        struct Foreground {
            static let name = "foreground"
            static let imageName = "foreground_1"
        }

        struct GloopFlow {
            static let name = "gloopFlow"
            static let imageName = "flow_1"
        }
    }
}
