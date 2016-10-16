//
//  main.swift
//  Fibonacci
//
//  Created by Ibrahim Kteish on 10/9/16.
//  Copyright © 2016 Ibrahim Kteish. All rights reserved.
//

import Foundation

public protocol NumericType: ExpressibleByIntegerLiteral {
    static func +(lhs: Self, rhs: Self) -> Self
    static func addWithOverflow(_ lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
}


extension UInt64 : NumericType {}


struct State<T:NumericType>  {
    
    let currentValue : T
    let nextValue: T?

    init?(current:T , nextValue:T?) {
        
        guard let nextValue = nextValue else { return nil }
        
        self.currentValue = current
        self.nextValue = nextValue
    }
    
    static func initial() -> State {
        
        return State<T>(current: 0 , nextValue: 1)!
    }
    
    func next() -> State? {
        
        return State(current: nextValue!, nextValue: add())
    }
    
    private func add() -> T? {
        
        let result = T.addWithOverflow(currentValue, nextValue!)
        
        if result.overflow {
            
            return nil
        }
        
        return result.0
    }
    
}

struct FibIterator<T:NumericType>: IteratorProtocol {
    
    var state = State<T>.initial()
    
    mutating func next() -> T? {
        let nextNumber = state.currentValue
        guard let state = state.next() else { return nil }
        self.state = state
        return nextNumber
    }
}


struct FibSequance<T:NumericType> : Sequence {
    
    func makeIterator() -> FibIterator<T> {
        return FibIterator<T>()
    }
}

var i = 0

let fibonacci = FibSequance<UInt64>()

for value in fibonacci {

    
    print(i," = " ,value)
    i+=1
}

