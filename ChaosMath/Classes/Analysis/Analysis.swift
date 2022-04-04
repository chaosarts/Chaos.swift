import Foundation

public func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

public func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}

public func rad(_ deg: Float) -> Float {
    deg * .pi / 180
}

public func deg(_ rad: Float) -> Float {
    rad * 180 / .pi
}
