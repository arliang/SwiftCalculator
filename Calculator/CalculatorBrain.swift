//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 阿良 on 16/6/11.
//  Copyright © 2016年 Arliang. All rights reserved.
//

import Foundation

enum Optional<T> {
    case none
    case some(T)
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(M_PI),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equals
    ]
    
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                accumulator = function(accumulator)
            case .binaryOperation(let function):
                excutePendingBinaryOperation()
                pending = PendingBinaryOpertionInfo(binaryFunction: function, firstOperand: accumulator)
            case .equals:
                excutePendingBinaryOperation()
            }
        }
    }
    
    private func excutePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOpertionInfo?
    
    /* structs pass by value
     * while classes pass by reference
     * and structs woun't be copied until they are accumulated
     */
    struct PendingBinaryOpertionInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}
