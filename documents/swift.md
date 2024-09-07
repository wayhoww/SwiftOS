Swift is not ready for embedded development. Even static array is not supported.

Therefore, do not turn-on noallocation mode. Instead, implement necessary memory-related functions in C.

Swift 6.0 is the first version supporting embedded development officially.
Swift 6.1 supports String in embedded development mod.

Compiling assembly code via SwiftPM might be possible via Plugin.

C/C++ is natively supported by SwiftPM.

C/C++ packages can be imported directly in Swift source codes.


To make vscode swift plugin work, .sourcekit-lsp/config.json is required for embedded development.


reference：
https://github.com/swiftlang/swift/blob/main/docs/EmbeddedSwift/UserManual.md
