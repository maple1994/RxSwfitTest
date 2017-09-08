//
//  Calculator.swift
//  MyRx
//
//  Created by Maple on 2017/9/8.
//  Copyright © 2017年 Maple. All rights reserved.
//

enum Operator {
    case addition
    case substraction
    case multiplication
    case division
}

enum CalculatorCommand {
    case clear
    case changeSign
    case percent
    case operation(Operator)
    case equal
    case addNumber(Character)
    case addDot
}

enum CalculatorState {
    case oneOperand(screen: String)
    case oneOperandAndOperator(operand: Double, operator: Operator)
    case twoOperandAndOperator(operand: Double, operator: Operator, screen: String)
}

extension CalculatorState {
    static let initial = CalculatorState.oneOperand(screen: "0")
    
    func mapScreen(transform: (String) -> String) -> CalculatorState {
        switch self {
        case let .oneOperand(screen):
            return .oneOperand(screen: transform(screen))
        case let .oneOperandAndOperator(operand, operat):
            return .twoOperandAndOperator(operand: operand, operator: operat, screen: transform("0"))
        case let .twoOperandAndOperator(operand, operat, screen):
            return .twoOperandAndOperator(operand: operand, operator: operat, screen: transform(screen))
        }
    }
    
    var screen: String {
        switch self {
        case let .oneOperand(screen):
            return screen
        case .oneOperandAndOperator(operand: _, operator: _):
            return "0"
        case let .twoOperandAndOperator(operand: _, operator: _, screen: screen):
            return screen
        }
    }
    
    var sign: String {
        switch self {
        case .oneOperand:
            return ""
        case let .oneOperandAndOperator(operand: _, operator: o):
            return o.sign
        case let .twoOperandAndOperator(operand: _, operator: o, screen: _):
            return o.sign
        }
    }
}

extension CalculatorState {
    static func reduce(state: CalculatorState, _ x: CalculatorCommand) -> CalculatorState {
        switch x {
        case .clear:
            return CalculatorState.initial
        case .addNumber(let c):
            return state.mapScreen(transform: { (str) -> String in
                return str == "0" ? String(c) : str + String(c)
            })
        case .addDot:
            return state.mapScreen {
                $0.range(of: ".") == nil ? $0 + "." : $0
            }
        case .changeSign:
            return state.mapScreen {
                "\(-(Double($0) ?? 0.0))"
            }
        case .percent:
            return state.mapScreen {
                 "\((Double($0) ?? 0.0) / 100.0)"
            }
        case .operation(let o):
            switch state {
            case let .oneOperand(screen):
                return .oneOperandAndOperator(operand: screen.doubleValue, operator: o)
            case let .oneOperandAndOperator(operand, _):
                return .oneOperandAndOperator(operand: operand, operator: o)
            case let .twoOperandAndOperator(operand, oldOperator, screen):
                return .twoOperandAndOperator(operand: oldOperator.perform(operand, screen.doubleValue), operator: o, screen: "0")
            }
        case .equal:
            switch state {
                case let .twoOperandAndOperator(operand, opeart, screen):
                let result = opeart.perform(operand, screen.doubleValue)
                return .oneOperand(screen: String(result))
            default:
                return state
            }
        }
    }
}

extension Operator {
    var sign: String {
        switch self {
        case .addition:
            return "+"
        case .substraction:
            return "-"
        case .multiplication:
            return "x"
        case .division:
            return "/"
        }
    }
    
    var perform: (Double, Double) -> Double {
        switch self {
        case .addition:
            return (+)
        case .substraction:
            return (-)
        case .multiplication:
            return (*)
        case .division:
            return (/)
        }
    }
}

private extension String {
    var doubleValue: Double {
        guard let double = Double(self) else {
            return Double.infinity
        }
        return double
    }
}










