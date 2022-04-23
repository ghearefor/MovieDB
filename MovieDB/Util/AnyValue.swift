//
//  AnyValue.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import Foundation

enum AnyValue: Codable {
    case integer(Int)
    case double(Double)
    case float(Float)
    case string(String)
    case boolean(Bool)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            self = .integer(intValue)
            return
        }

        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
            return
        }

        if let floatValue = try? container.decode(Float.self) {
            self = .float(floatValue)
            return
        }

        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }

        if let boolValue = try? container.decode(Bool.self) {
            self = .boolean(boolValue)
            return
        }

        if container.decodeNil() {
            self = .string("")
            return
        }

        throw DecodingError.typeMismatch(AnyValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        case .float(let floatValue):
            try container.encode(floatValue)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        case .boolean(let booleanValue):
            try container.encode(booleanValue)
        case .null:
            try container.encode(self)
        }
    }

    var doubleValue: Double {
        switch self {
        case .double(let doubleVelue):
            return doubleVelue
        case .string(let stringValue):
            return stringValue.toDouble()
        case .integer(let intValue):
            return (Double(intValue))
        case .float(let floatValue):
            return (Double(floatValue))
        default:
            return 0.0
        }
    }

    var floatValue: Float {
        switch self {
        case .double(let doubleVelue):
            return Float(doubleVelue)
        case .string(let stringValue):
            return stringValue.toFloat()
        case .integer(let intValue):
            return (Float(intValue))
        case .float(let floatValue):
            return floatValue
        default:
            return 0.0
        }
    }

    var intValue: Int {
        switch self {
        case .double(let doubleVelue):
            return Int(doubleVelue)
        case .string(let stringValue):
            return stringValue.toInt()
        case .integer(let intValue):
            return intValue
        case .float(let floatValue):
            return Int(floatValue)
        default:
            return 0
        }
    }

    var stringValue: String {
        switch self {
        case .double(let doubleVelue):
            return "\(doubleVelue)"
        case .string(let stringValue):
            return stringValue
        case .integer(let intValue):
            return "\(intValue)"
        case .float(let floatValue):
            return "\(floatValue)"
        default:
            return ""
        }
    }

    var booleanValue: Bool {
        switch self {
        case .boolean(let boolValue):
            return boolValue
        case .integer(let intValue):
            return intValue == 1
        case .string(let stringValue):
            let bool = stringValue.toInt() == 1
            return bool
        default:
            return false
        }
    }
}

