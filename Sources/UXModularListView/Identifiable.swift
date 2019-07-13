//
//  Identifiable.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import Swift


public protocol Identifiable {
    associatedtype ID: Hashable

    var id: ID { get }
}
