//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 阿良 on 16/6/11.
//  Copyright © 2016年 Arliang. All rights reserved.
//

import Foundation

enum Optional<T> {
    case None
    case Some(T)
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "+": Operation.BinaryOperation({
            print("\($0) + \($1)")
            return $0 + $1
        }),
        "-": Operation.BinaryOperation({ $0 - $1 }),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "=": Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                print("Constant(\(value)): \(accumulator)")
                accumulator = value
            case .UnaryOperation(let function):
                print("Unary\(symbol): \(accumulator) = \(function(accumulator))")
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                pending = PendingBinaryOpertionInfo(binaryFunction: function, firstOperand: accumulator)
                print("BinaryOperation: \(pending?.firstOperand) accumulator:\(accumulator)")
            case .Equals:
                if pending != nil {
                    print("Equals: \(pending?.firstOperand) accumulator:\(accumulator)")
                    accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
                    print("Equals after accumulator:\(accumulator)")
                    pending = nil
                }
            }
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