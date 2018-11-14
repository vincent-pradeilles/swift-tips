//: [Previous](@previous)

/*
 Swift's `Codable` framework does a great job at seamlessly
 decoding entities from a JSON stream. However, when we
 integrate web-services, we are sometimes left to deal with
 JSONs that require behaviors that `Codable` does not provide
 out-of-the-box.
 
 For instance, we might have a string-based or integer-based
 `enum`, and be required to set it to a default value when
 the data found in the JSON does not match any of its cases.
 
 We might be tempted to implement this via an extensive
 `switch` statement over all the possible cases, but there
 is a much shorter alternative through the initializer `init?(rawValue:)`:
 */

import Foundation

enum State: String, Decodable {
    case active
    case inactive
    case undefined
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedString = try container.decode(String.self)
        
        self = State(rawValue: decodedString) ?? .undefined
    }
}

let data = """
["active", "inactive", "foo"]
""".data(using: .utf8)!

let decoded = try! JSONDecoder().decode([State].self, from: data)

print(decoded) // [State.active, State.inactive, State.undefined]

//: [Next](@next)
