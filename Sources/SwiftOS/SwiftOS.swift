import Cibrary



let PTR_UART0 = UnsafeMutableRawPointer(bitPattern: 0x0900_0000)!


func getchar() -> Int32 {
    let ptrData = PTR_UART0.bindMemory(to: UInt32.self, capacity: 1)
    let ptrFlag = PTR_UART0.advanced(by: 0x18).bindMemory(to: UInt32.self, capacity: 1)

    while Cibrary.read_volatile_u32(ptrFlag) & (1 << 4) != 0 {}
    return Int32(Cibrary.read_volatile_u32(ptrData))
}


@_cdecl("kmain")
public func kmain() {
    let ptrDtb = UnsafeRawPointer(bitPattern: 0x4000_0000)!
    let tree = readDeviceTree(addr: ptrDtb)
    dumpDeviceTreeNode(node: tree, indent: 0)
    print("End of kmain")
    while true {}
}

@_cdecl("irq_handler")
public func irq_handler(arg1: Int64, arg2: Int64, arg3: Int64) {
    print("IRQ 0x\(String(arg1, radix: 16)) 0x\(String(arg2, radix: 16)) 0x\(String(arg3, radix: 16))")
    while true {}
}
