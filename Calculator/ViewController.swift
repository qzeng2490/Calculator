//
//  ViewController.swift
//  Calculator
//
//  Created by Zeng Qiang on 16/6/8.
//  Copyright © 2016年 Zeng Qiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet private weak var display: UILabel!
    
    private var isInMiddleOfTypying: Bool = false
    private var isFloat: Bool = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if isInMiddleOfTypying {
            if digit == "." && isFloat{
                return
            } else if digit == "." {
                isFloat = true
            }
            display.text = display.text! + digit
            
        } else {
            if digit == "."  {
                display.text = "0."
                isFloat = true
            } else {
                display.text = digit
            }
            
        }
        isInMiddleOfTypying = true
        
    }
    
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save(sender: UIButton) {
            savedProgram = brain.program
    }
    
    
    @IBAction func store(sender: UIButton) {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    @IBAction private func performOperation(sender: UIButton) {
        if isInMiddleOfTypying {
            brain.setOperand(displayValue)
            isInMiddleOfTypying = false
            isFloat = false
        }
        
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        if(brain.result - floor(brain.result) != 0) {
            displayValue = brain.result
        }else {
            display.text = String(Int(brain.result))
        }
        
        
    }
    
    @IBAction func Clear(sender: UIButton) {
        brain.clear()
        display.text = "0"
        isFloat = false
        isInMiddleOfTypying = false
        savedProgram = nil
    }

}

