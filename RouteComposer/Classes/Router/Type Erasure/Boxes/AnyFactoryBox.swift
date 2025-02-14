//
// RouteComposer
// AnyFactoryBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation

protocol AnyFactoryBox: AnyFactory {

    associatedtype FactoryType: AbstractFactory

    var factory: FactoryType { get set }

    init?(_ factory: FactoryType, action: AnyAction)

}

protocol PreparableAnyFactory: AnyFactory, PreparableEntity {

    var isPrepared: Bool { get set }

}

extension AnyFactoryBox {

    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
        factories
    }

}

extension AnyFactoryBox where Self: PreparableAnyFactory, Self: MainThreadChecking {

    mutating func prepare<Context>(with context: Context) throws {
        assertIfNotMainThread()
        guard let typedContext = Any?.some(context as Any) as? FactoryType.Context else {
            throw RoutingError.typeMismatch(type: type(of: context),
                                            expectedType: FactoryType.Context.self,
                                            .init("\(String(describing: factory.self)) does not accept \(String(describing: context.self)) as a context."))
        }
        try factory.prepare(with: typedContext)
        isPrepared = true
    }

}

extension AnyFactory where Self: CustomStringConvertible & AnyFactoryBox {

    var description: String {
        String(describing: factory)
    }

}

#endif
