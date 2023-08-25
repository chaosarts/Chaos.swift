//
//  File.swift
//  
//
//  Created by fu.lam.diep on 27.12.22.
//

import Foundation
import Combine

@propertyWrapper public struct CurrentValue<Subject> {

    public var wrappedValue: Subject {
        get { projectedValue.value }
        set { projectedValue.value = newValue }
    }

    public var projectedValue: CurrentValueSubject<Subject, Never>

    public init(wrappedValue: Subject) {
        projectedValue = CurrentValueSubject(wrappedValue)
    }
}
