//
//  File.swift
//  
//
//  Created by Pranith Kumar Margam on 13/08/23.
//

import Foundation
import ArgumentParser

enum InputFormateError: Error {
    case formateError(_ message: String)
}
struct FractionsCalulator: ParsableCommand {
    enum Operation: String, ExpressibleByArgument {
        case add, subtract, multiply, divide
        func description() -> String {
            switch self {
            case .add:
                return "Addition"
            case .subtract:
                return "Substraction"
            case .multiply:
                return "Multiplication"
            case .divide:
                return "Division"
            }
        }
    }
    
    mutating func run() throws {
        print("Please enter input")
        if let input = readLine() {
            if input == "exit" {
                return
            }
            let result = self.convertInputAndPerformCalculations(inputString: input)
            switch result {
            case .success(let (_,description)):
                print(description)
                FractionsCalulator.main()
               break
            case .failure(InputFormateError.formateError(let message)):
                print(message)
                FractionsCalulator.main()
                break
            }
        }
    }
    // MARK: Input validations
    func convertInputAndPerformCalculations(inputString: String) -> Result<(MixedNumber, String), InputFormateError> {
        let inputComponents = inputString.split(separator: " ").map({$0.trimmingCharacters(in: .whitespaces)})
        if inputComponents.count == 0 {
            return .failure(.formateError("input not entered"))
        }
        if inputComponents.first != "?" {
            return .failure(.formateError("Commong Promt is missing.Please add Commong Promt in input"))
        }
        if inputComponents.count < 4 {
            return .failure(.formateError("Invalid input"))
        }
        
        let firstNumber = inputComponents[1]
        let operationComponent = inputComponents[2]
        let secondNumber = inputComponents[3]
       
        do {
            let operation = try self.inputOperation(input: operationComponent)
            let firstMixedNumber: MixedNumber = try self.inputToMixedNumber(input: firstNumber)
            let secondMixedNumber: MixedNumber = try self.inputToMixedNumber(input: secondNumber)
            if let result = performFractionCalculations(firstMixedNumber, secondMixedNumber, operation: operation) {
                let description = "\(operation.description()) result: \(result.description())"
                return .success((result,description))
            }
        } catch let err {
            return .failure(err as? InputFormateError ?? .formateError("Formate Error"))
        }
        
        return .failure(.formateError("Unexpected result"))
    }
    
    // MARK: Input to Data conversions
    private func inputOperation(input: String) throws -> Operation {
        var operation: Operation = .add
        if input == "+" {
            operation = .add
        }else if input == "-" {
            operation = .subtract
        }else if input == "*" {
            operation = .multiply
        }else if input == "/" {
            operation = .divide
        } else {
            throw InputFormateError.formateError("Invalid Operetion")
        }
        return operation
    }
    
    private func inputToMixedNumber(input: String) throws -> MixedNumber {
        if input.contains("&") {//mixed number
            let componets = input.components(separatedBy: "&")
            do {
                let fraction = try parseFractionInput(componets.last ?? "")
                let wholeNum = Int(componets.first ?? "") ?? 0
                return MixedNumber(wholePart: wholeNum, numerator: fraction?.numerator ?? 0, denominator: fraction?.denominator ?? 0)
            } catch let err {
                throw err
            }
           
        } else {
            do {
                let fraction = try parseFractionInput(input)
                return MixedNumber(wholePart: 0, numerator: fraction?.numerator ?? 0, denominator: fraction?.denominator ?? 0)
            }catch let err {
                throw err
            }
           
        }
    }
    
    private func parseFractionInput(_ input: String) throws -> Fraction? {
        let components = input.components(separatedBy: "/")
        if components.count == 1, let number = Int(components.first ?? "") {
            return Fraction(numerator: number, denominator: 1)
        }
        guard components.count == 2,
              let numerator = Int(components[0]),
              let denominator = Int(components[1]),
              denominator != 0 else {
            throw InputFormateError.formateError("Invalid input")
        }
        
        return Fraction(numerator: numerator, denominator: denominator)
    }
        
    private func performFractionCalculations(_ number1: MixedNumber, _ number2: MixedNumber, operation: Operation) -> MixedNumber? {
        
        let num1 = convertMixedFractionToFraction(number: number1)
        let num2 = convertMixedFractionToFraction(number: number2)
        var resultFraction: Fraction?
        switch operation {
        case .add:
            resultFraction = addTwoFractions(number1: num1, number2: num2)
        case .subtract:
            resultFraction = subtractTwoFractions(number1: num1, number2: num2)
        case .multiply:
            resultFraction = mulitiplyTwoFractions(number1: num1, number2: num2)
        case .divide:
            resultFraction = divideTwoFractions(number1: num1, number2: num2)
        }

        return convertFractionToMixedFraction(number: resultFraction)
    }
            
    private func convertMixedFractionToFraction(number: MixedNumber) -> Fraction {
        let newNumerator = (number.wholePart * number.denominator) + number.numerator
        return Fraction(numerator: newNumerator, denominator: number.denominator)
    }
    
    private func convertFractionToMixedFraction(number: Fraction?) -> MixedNumber? {
        guard var number = number else {
            return nil
        }
        if number.denominator < 0 {
            number.denominator *= -1
            number.numerator *= -1
        }
        let divisor = gcd(number.numerator, number.denominator)
        let newFraction = Fraction(numerator: number.numerator / divisor, denominator: number.denominator / divisor)
        let wholePart = newFraction.numerator / newFraction.denominator
        let remainder = newFraction.numerator % newFraction.denominator
        
        if remainder == 0 {
            return MixedNumber(wholePart: wholePart, numerator: 1, denominator: 1)
        }
        return MixedNumber(wholePart: wholePart, numerator: remainder, denominator: newFraction.denominator)
    }
    
    // MARK: Calculations
    private func addTwoFractions(number1: Fraction, number2: Fraction) -> Fraction {
        let commonDenominator = number1.denominator * number2.denominator
        let newNumerator1 = number1.numerator * number2.denominator
        let newNumerator2 = number2.numerator * number1.denominator
        let sumNumerator = newNumerator1 + newNumerator2
        let divisor = gcd(sumNumerator, commonDenominator)
        let resultN = sumNumerator / divisor
        let resulD = commonDenominator / divisor
        return Fraction(numerator: resultN, denominator: resulD)
    }
    
    private func subtractTwoFractions(number1: Fraction, number2: Fraction) -> Fraction {
        let commonDenominator = number1.denominator * number2.denominator
        let newNumerator1 = number1.numerator * number2.denominator
        let newNumerator2 = number2.numerator * number1.denominator
        let sumNumerator = newNumerator1 - newNumerator2
        let divisor = gcd(sumNumerator, commonDenominator)
        let resultN = sumNumerator / divisor
        let resulD = commonDenominator / divisor
        return Fraction(numerator: resultN, denominator: resulD)
    }
    
    private func mulitiplyTwoFractions(number1: Fraction, number2: Fraction) -> Fraction {
        let resultN = number1.numerator * number2.numerator
        let resultD = number1.denominator * number2.denominator
        return Fraction(numerator: resultN, denominator: resultD)
    }
    
    private func divideTwoFractions(number1: Fraction, number2: Fraction) -> Fraction {
        let resultN = number1.numerator * number2.denominator
        let resultD = number1.denominator * number2.numerator
        return Fraction(numerator: resultN, denominator: resultD)
    }
    
    private func gcd(_ a:Int,_ b:Int) -> Int {
        if b == 0 {
            return a
        } else {
            return gcd(b, a % b)
        }
    }
}

FractionsCalulator.main()

struct Fraction {
    var numerator: Int
    var denominator: Int
    
    init(numerator: Int, denominator: Int) {
        self.numerator = numerator
        self.denominator = denominator
        simplify()
    }
    
    mutating func simplify() {
        if denominator < 0 {
            numerator *= -1
            denominator *= -1
        }
    }
}

struct MixedNumber {
    var wholePart: Int
    var numerator: Int
    var denominator: Int
    
    init(wholePart: Int, numerator: Int, denominator: Int) {
        self.wholePart = wholePart
        self.numerator = numerator
        self.denominator = denominator
        simplify()
    }
    
    mutating func simplify() {
        if denominator < 0 {
            numerator *= -1
            denominator *= -1
        }
    }
    
    func description() -> String {
        if (wholePart == 0) {
            if numerator == 1 && denominator == 1 {
                return "\(wholePart)"
            }
            
            return "\(numerator)/\(denominator)"
        }
        if numerator < 0 || denominator < 0 {
            return "-\(abs(wholePart))&\(abs(numerator))/\(abs(denominator))"
        }
        if numerator == 1 && denominator == 1 {
            return "\(wholePart)"
        }
        return "\(wholePart)&\(numerator)/\(denominator)"
    }
}
