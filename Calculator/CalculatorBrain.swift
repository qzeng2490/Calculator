//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Zeng Qiang on 16/6/8.
//  Copyright © 2016年 Zeng Qiang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accumulator = 0.0
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "+": Operation.BinaryOperation(){ $0 + $1},
        "-": Operation.BinaryOperation(){ $0 - $1},
        "*": Operation.BinaryOperation(){ $0 * $1},
        "/": Operation.BinaryOperation(){ $0 / $1},
        "=": Operation.Equals
    ]
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let constant = operations[symbol] {
            switch constant {
            case .Constant(let v):
                accumulator = v
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePending()
                pending = PendingBinaryOperationInfo(binaryFunc: function,firstOperand: accumulator)
            case .Equals:
                executePending()
            }
        }
        
    }
    
    private func executePending() {
        if pending != nil {
            accumulator = pending!.binaryFunc(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    
    
    private var pending: PendingBinaryOperationInfo?
    
    struct  PendingBinaryOperationInfo {
        var binaryFunc: (Double, Double) -> Double
        var firstOperand : Double
    }
    func clear() {
        pending = nil
        accumulator = 0.0
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}