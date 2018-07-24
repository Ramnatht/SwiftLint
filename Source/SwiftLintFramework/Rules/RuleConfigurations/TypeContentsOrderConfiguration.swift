import Foundation

enum TypeContent: String {
    case `case` = "case"
    case typeAlias = "type_alias"
    case associatedType = "associated_type"
    case subtype = "subtype"
    case typeProperty = "type_property"
    case instanceProperty = "instance_property"
    case ibOutlet = "ib_outlet"
    case ibInspectable = "ib_inspectable"
    case initializer = "initializer"
    case typeMethod = "type_method"
    case viewLifeCycleMethod = "view_life_cycle_method"
    case ibAction = "ib_action"
    case otherMethod = "other_method"
    case `subscript` = "subscript"
}

public struct TypeContentsOrderConfiguration: RuleConfiguration {
    private(set) var severityConfiguration = SeverityConfiguration(.warning)
    private(set) var order: [[TypeContent]] = [
        [.case],
        [.typeAlias, .associatedType],
        [.subtype],
        [.typeProperty],
        [.instanceProperty],
        [.ibInspectable],
        [.ibOutlet],
        [.initializer],
        [.typeMethod],
        [.viewLifeCycleMethod],
        [.ibAction],
        [.otherMethod],
        [.subscript]
    ]

    public var consoleDescription: String {
        return severityConfiguration.consoleDescription +
            ", order: \(String(describing: order))"
    }

    public mutating func apply(configuration: Any) throws {
        guard let configuration = configuration as? [String: Any] else {
            throw ConfigurationError.unknownConfiguration
        }

        var customOrder = [[TypeContent]]()
        if let custom = configuration["order"] as? [Any] {
            for entry in custom {
                if let singleEntry = entry as? String {
                    if let typeContent = TypeContent(rawValue: singleEntry) {
                        customOrder.append([typeContent])
                    }
                } else if let arrayEntry = entry as? [String] {
                    let typeContents = arrayEntry.compactMap { TypeContent(rawValue: $0) }
                    customOrder.append(typeContents)
                }
            }
        }

        if !customOrder.isEmpty {
            self.order = customOrder
        }
    }
}

extension TypeContentsOrderConfiguration: Equatable {
    public static func == (lhs: TypeContentsOrderConfiguration, rhs: TypeContentsOrderConfiguration) -> Bool {
        guard lhs.order.count == rhs.order.count else { return false }

        for (leftIndex, leftOrderEntry) in lhs.order.enumerated() {
            guard rhs.order[leftIndex] == leftOrderEntry else { return false }
        }

        return lhs.severityConfiguration == rhs.severityConfiguration
    }
}
