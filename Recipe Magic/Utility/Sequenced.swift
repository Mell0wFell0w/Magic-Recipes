//
//  Sequenced.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import Foundation

protocol Sequenced {
    var sequence: Int { get }
}

func sequenceSort(a: Sequenced, b: Sequenced) -> Bool {
    a.sequence < b.sequence
}
