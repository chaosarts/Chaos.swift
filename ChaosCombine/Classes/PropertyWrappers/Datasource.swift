//
//  File.swift
//  
//
//  Created by fu.lam.diep on 27.12.22.
//

import Foundation
import Combine

private typealias PropertyWrapper = CurrentValue
private protocol _DatasourceProperty {}
extension PropertyWrapper: _DatasourceProperty {}

@propertyWrapper public struct Datasource<ObjectType> {
    @dynamicMemberLookup public struct Wrapper {
        internal let object: ObjectType

        private let datasourcePropertiesByName: [String: _DatasourceProperty]

        public subscript<Subject>(dynamicMember label: String) -> AnyPublisher<Subject, Never>? {
            guard let observableObjectProperty = datasourcePropertiesByName["_\(label)"] else {
                return nil
            }
            return (observableObjectProperty as? PropertyWrapper<Subject>)?.projectedValue.eraseToAnyPublisher()
        }

        internal init(object: ObjectType) {
            self.object = object

            var datasourcePropertiesByName = [String: _DatasourceProperty]()
            var objectMirror: Mirror? = Mirror(reflecting: object)
            while let _objectMirror = objectMirror {
                for child in _objectMirror.children {
                    guard let value = child.value as? _DatasourceProperty,
                            let label = child.label else {
                        continue
                    }
                    datasourcePropertiesByName[label] = value
                }

                objectMirror = _objectMirror.superclassMirror
            }

            self.datasourcePropertiesByName = datasourcePropertiesByName
        }
    }

    public var wrappedValue: ObjectType {
        projectedValue.object
    }

    public let projectedValue: Wrapper

    public init(wrappedValue: ObjectType) {
        self.projectedValue = Wrapper(object: wrappedValue)
    }
}
