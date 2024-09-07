import Cibrary;


struct DeviceTreeHeader {
    let magic: UInt32
    let totalsize: UInt32
    let offDtStruct: UInt32
    let offDtStrings: UInt32
    let offMemRsvmap: UInt32
    let version: UInt32
    let lastCompVersion: UInt32
    let bootCpuidPhys: UInt32
    let sizeDtStrings: UInt32
    let sizeDtStruct: UInt32
}


func readDeviceTreeHeader(addr: UnsafeRawPointer) -> DeviceTreeHeader {
    var out = addr.load(as: DeviceTreeHeader.self)

    let numElements = MemoryLayout<DeviceTreeHeader>.size / MemoryLayout<UInt32>.size

    let rawAddr = withUnsafePointer(to: &out) { $0 }
    let mutAddr = UnsafeMutableRawPointer(mutating: rawAddr)
    let u32Addr = mutAddr.bindMemory(to: UInt32.self, capacity: numElements)

    for i in 0..<numElements {
        u32Addr[i] = u32Addr[i].bigEndian
    }

    return out
}


enum DeviceTreeNodeToken: UInt32 {
    case FDT_BEGIN_NODE = 0x1
    case FDT_END_NODE = 0x2
    case FDT_PROP = 0x3
    case FDT_NOP = 0x4
    case FDT_END = 0x9
}

class AsciiString {
    var data: [UInt8] = []

    init() {
        data.append(0)
    }

    init(_ addr: UnsafeRawPointer) {
        var current = addr
        while true {
            let c = current.load(as: UInt8.self)
            current = current.advanced(by: 1)
            data.append(c)

            if c == 0 {
                break
            }

        }
    }

    func toString() -> String {
        var out = ""
        for c in data.dropLast() {
            out.append(Character(UnicodeScalar(c)))
        }
        return out
    }
}

func isString(_ data: [UInt8]) -> Bool {
    // if last is not 0, it is not a string
    if data[data.count - 1] != 0 {
        return false
    }

    // if any 0 in the middle, it is not a string
    for i in 0..<data.count - 1 {
        if (data[i] < 32 || data[i] >= 127) && data[i] != 0 {
            return false
        }
    }

    return true
}


func hexString(_ u8: UInt8) -> String {
    let dig1 = u8 >> 4
    let dig2 = u8 & 0xF

    let hex1 = String(dig1, radix: 16, uppercase: false)
    let hex2 = String(dig2, radix: 16, uppercase: false)

    return hex1 + hex2
}


func smartToString(_ data: [UInt8]) -> String {
    if data.count == 0 {
        return "<empty>"
    }

    var out = ""

    if isString(data) {
        for c in data.dropLast() {
            if c == 0 {
                out += "<null>"
            }
            out.append(Character(UnicodeScalar(c)))
        }
        return out
    } else {
        out.append("HEX ")
        for i in 0..<data.count {
            out.append(hexString(data[i]))
            out.append(" ")
        }
    }

    return out
}

class DeviceTreeNode {
    var name: AsciiString = AsciiString()
    var properties: [(AsciiString, [UInt8])] = []
    var children: [DeviceTreeNode] = []
}

func readDeviceTreeNode(addr: UnsafeRawPointer, size: Int, stringTableAddr: UnsafeRawPointer) -> DeviceTreeNode {
    var nodes: [DeviceTreeNode] = []

    var current = addr;
    let end = addr.advanced(by: size)

    var out: DeviceTreeNode? = nil

    while current < end {
        let tokenInt = current.load(as: UInt32.self).bigEndian
        current = current.advanced(by: 4)

        let token = DeviceTreeNodeToken(rawValue: tokenInt)!


        switch token {
        case .FDT_BEGIN_NODE:
            if out != nil {
                print("Error: FDT_BEGIN_NODE after FDT_END")
                undefined()
            }

            let newNode = DeviceTreeNode()
            if nodes.count > 0 {
                nodes[nodes.count - 1].children.append(newNode)
            }
            nodes.append(newNode)

            let name = AsciiString(current)
            current = current.advanced(by: name.data.count).alignedUp(toMultipleOf: 4)
            nodes[nodes.count - 1].name = name
        
        case .FDT_END_NODE:
            let last = nodes.popLast()
            if nodes.count == 0 {
                out = last;
            }

        case .FDT_PROP:
            let len = current.load(as: UInt32.self).bigEndian
            current = current.advanced(by: MemoryLayout<UInt32>.size)
            let nameoff = current.load(as: UInt32.self).bigEndian
            current = current.advanced(by: MemoryLayout<UInt32>.size)
            var value = [UInt8](repeating: 0, count: Int(len))
            for i in 0..<Int(len) {
                value[i] = current.load(as: UInt8.self)
                current = current.advanced(by: 1)
            }
            current = current.alignedUp(toMultipleOf: 4);
            let name = AsciiString(stringTableAddr.advanced(by: Int(nameoff)))
            nodes[nodes.count - 1].properties.append((name, value))

        case .FDT_NOP:
            break
        case .FDT_END:
            break
        }
    }

    return out!
}


func dumpDeviceTreeNode(node: DeviceTreeNode, indent: Int) {
    let indentStr = String(repeating: " ", count: indent)
    print("\(indentStr)Node: \(node.name.toString())")
    for (name, value) in node.properties {
        print("\(indentStr)  \(name.toString()): \(smartToString(value))")
    }
    for child in node.children {
        dumpDeviceTreeNode(node: child, indent: indent + 2)
    }
}


func readDeviceTree(addr: UnsafeRawPointer) -> DeviceTreeNode {
    let fdtHeader = readDeviceTreeHeader(addr: addr)
    return readDeviceTreeNode(addr: addr.advanced(by: Int(fdtHeader.offDtStruct)), size: Int(fdtHeader.sizeDtStruct), stringTableAddr: addr.advanced(by: Int(fdtHeader.offDtStrings)))
}
