//
//  Model.swift
//  Calculator
//
//  Created by Denis Semerych on 22.08.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import Foundation

class Calculator {
    var numArr = [Double]()
    var ops = [Int]()
    func save(numbers: String, mod: Int) -> String {
        var num = Double(numbers)
        numArr.append(num!)
        opPreority(of: mod, to: &ops, result: &num!)
        return String(num!)
    }
    func saveLastOp (_ op: Int) {
        ops.removeLast()
        ops.append(op)
    }
    func opPreority (of op: Int, to prevOp: inout [Int], result: inout Double) {
        switch op {
        case 12:
            if prevOp.count != 0 {performCalculations(operator: prevOp.removeLast(), result: &result)}
        case 13 where prevOp.count != 0:
            performCalculations(operator: prevOp.removeLast(), result: &result)
            opPreority(of: op, to: &prevOp, result: &result)
        case 13:
            if numArr.count > 2 {performCalculations(operator: op, result: &result)} else {prevOp.append(op)}
        case 14 where prevOp.count != 0:
            performCalculations(operator: prevOp.removeLast(), result: &result)
            opPreority(of: op, to: &prevOp, result: &result)
        case 14:
            if numArr.count > 2 {performCalculations(operator: op, result: &result)} else {prevOp.append(op)}
        case 15 where (prevOp.last == 15 || prevOp.last == 16):
            performCalculations(operator: prevOp.removeLast(), result: &result)
            opPreority(of: op, to: &prevOp, result: &result)
        case 15:
            if numArr.count > 2 {performCalculations(operator: op, result: &result)} else {prevOp.append(op)}
        case 16 where (prevOp.last == 15 || prevOp.last == 16):
            performCalculations(operator: prevOp.removeLast(), result: &result)
            opPreority(of: op, to: &prevOp, result: &result)
        case 16:
            if numArr.count > 2 {performCalculations(operator: op, result: &result)} else {prevOp.append(op)}
        default:
            break
        }
    }
    func performCalculations(operator op: Int, result: inout Double)
    {
        switch op {
        case 13:
            result = operate{$1 + $0}
        case 14:
            result = operate{$1 - $0}
        case 15:
            result = operate{$1 * $0}
        case 16:
            result = operate{$1 / $0}
        default:
            break
        }
    }
    func operate (_ op :(Double, Double) -> Double) -> Double {
        let num = op(numArr.remove(at: numArr.endIndex - 1), numArr.removeLast())
        return num
    }
}

