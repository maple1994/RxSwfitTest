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
                // 如果只有一个操作数，就添加操作符
                return .oneOperandAndOperator(operand: screen.doubleValue, operator: o)
                // 如果有一个操作数和操作符，就替换操作符
            case let .oneOperandAndOperator(operand, _):
                return .oneOperandAndOperator(operand: operand, operator: o)
                // 如果有两个操作数和一个操作符，将他们的计算结果作为操作数保留，然后加入新的操作符，以及一个操作数 0.
            case let .twoOperandAndOperator(operand, oldOperator, screen):
                return .twoOperandAndOperator(operand: oldOperator.perform(operand, screen.doubleValue), operator: o, screen: "0")
            }
        case .equal:
            switch state {
                //如果当前有两个操作数和一个操作符，将他们的计算结果作为操作数保留。否则什么都不做。
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










