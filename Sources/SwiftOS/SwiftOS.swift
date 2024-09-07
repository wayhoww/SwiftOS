import Cibrary

struct FdtHeader {
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

func readFdtHeader(addr: UnsafeRawPointer) -> FdtHeader {
    var out = addr.load(as: FdtHeader.self)

    let numElements = MemoryLayout<FdtHeader>.size / MemoryLayout<UInt32>.size

    let rawAddr = withUnsafePointer(to: &out) { $0 }
    let mutAddr = UnsafeMutableRawPointer(mutating: rawAddr)
    let u32Addr = mutAddr.bindMemory(to: UInt32.self, capacity: numElements)

    for i in 0..<numElements {
        u32Addr[i] = u32Addr[i].bigEndian
    }

    return out
}


let PTR_UART0 = UnsafeMutableRawPointer(bitPattern: 0x0900_0000)!

func putchar(_ c: Int32) {
    Cibrary.write_volatile_u32(PTR_UART0.bindMemory(to: UInt32.self, capacity: 1), UInt32(c));
}

func getchar() -> Int32 {
    let ptrData = PTR_UART0.bindMemory(to: UInt32.self, capacity: 1)
    let ptrFlag = PTR_UART0.advanced(by: 0x18).bindMemory(to: UInt32.self, capacity: 1)

    while Cibrary.read_volatile_u32(ptrFlag) & (1 << 4) != 0 {}
    return Int32(Cibrary.read_volatile_u32(ptrData))
}


@_cdecl("kmain")
public func kmain() {
    let addrDtb = UnsafeRawPointer(bitPattern: 0x4000_0000)!
    let fdtHeader = readFdtHeader(addr: addrDtb)
    print("FDT Header: 0x\(String(fdtHeader.magic, radix: 16))")
    print("FDT Total Size: 0x\(String(fdtHeader.totalsize, radix: 16))")


    while true {
        let c = getchar();
        putchar(Int32(c));
    }
}

@_cdecl("irq_handler")
public func irq_handler(arg1: Int64, arg2: Int64, arg3: Int64) {
    print("IRQ 0x\(String(arg1, radix: 16)) 0x\(String(arg2, radix: 16)) 0x\(String(arg3, radix: 16))")
    while true {}
}
