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
    private var internalProgram = [AnyObject]()
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
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
        internalProgram.append(symbol)
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
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
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
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}