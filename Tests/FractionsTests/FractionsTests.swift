import XCTest
@testable import Fractions

final class FractionsTests: XCTestCase {
    func testInvalidInputs() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let fractionCal = FractionsCalulator()
        let result = fractionCal.convertInputAndPerformCalculations(inputString: "radom text")
        if case let .failure(.formateError(message)) = result {
            XCTAssertEqual(message, "Commong Promt is missing.Please add Commong Promt in input")
        }
        let result2 = fractionCal.convertInputAndPerformCalculations(inputString: "")
        if case let .failure(.formateError(message)) = result2 {
            XCTAssertEqual(message, "input not entered")
        }
        let result3 = fractionCal.convertInputAndPerformCalculations(inputString: "? 1/2")
        if case let .failure(.formateError(message)) = result3 {
            XCTAssertEqual(message, "Invalid input")
        }
        
        let result4 = fractionCal.convertInputAndPerformCalculations(inputString: "? 1/a + 1/b")
        if case let .failure(.formateError(message)) = result4 {
            XCTAssertEqual(message, "Invalid input")
        }
        
        let result5 = fractionCal.convertInputAndPerformCalculations(inputString: "? a + b")
        if case let .failure(.formateError(message)) = result5 {
            XCTAssertEqual(message, "Invalid input")
        }
        
        let result6 = fractionCal.convertInputAndPerformCalculations(inputString: "? 1/4 + b")
        if case let .failure(.formateError(message)) = result6 {
            XCTAssertEqual(message, "Invalid input")
        }
        
        let result7 = fractionCal.convertInputAndPerformCalculations(inputString: "? a + 1/2")
        if case let .failure(.formateError(message)) = result7 {
            XCTAssertEqual(message, "Invalid input")
        }
        
        let result8 = fractionCal.convertInputAndPerformCalculations(inputString: "? 3/4 & 1/2")
        if case let .failure(.formateError(message)) = result8 {
            XCTAssertEqual(message, "Invalid Operetion")
        }
    }
    
    func testCalculations() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let fractionCal = FractionsCalulator()
        let result = fractionCal.convertInputAndPerformCalculations(inputString: "? 1/2 * 3&3/4")
        if case let .success((num, _)) = result {
            XCTAssertEqual(num.wholePart, 1)
            XCTAssertEqual(num.numerator, 7)
            XCTAssertEqual(num.denominator, 8)
        }
        
        let result2 = fractionCal.convertInputAndPerformCalculations(inputString: "? 2&3/8 + 9/8")
        if case let .success((num, _)) = result2 {
            XCTAssertEqual(num.wholePart, 3)
            XCTAssertEqual(num.numerator, 1)
            XCTAssertEqual(num.denominator, 2)
        }
        
        let result3 = fractionCal.convertInputAndPerformCalculations(inputString: "? 1&3/4 - 2")
        if case let .success((num, _)) = result3 {
            XCTAssertEqual(num.wholePart, 0)
            XCTAssertEqual(num.numerator, -1)
            XCTAssertEqual(num.denominator, 4)
        }
        
        let result4 = fractionCal.convertInputAndPerformCalculations(inputString: "? 8/3 + 5/6")
        if case let .success((num, _)) = result4 {
            XCTAssertEqual(num.wholePart, 3)
            XCTAssertEqual(num.numerator, 1)
            XCTAssertEqual(num.denominator, 2)
        }
        
        let result5 = fractionCal.convertInputAndPerformCalculations(inputString: "? 8 + 5")
        if case let .success((num, _)) = result5 {
            XCTAssertEqual(num.wholePart, 13)
            XCTAssertEqual(num.numerator, 1)
            XCTAssertEqual(num.denominator, 1)
        }
        
        let result6 = fractionCal.convertInputAndPerformCalculations(inputString: "? -8 + -5")
        if case let .success((num, _)) = result6 {
            XCTAssertEqual(num.wholePart, -13)
            XCTAssertEqual(num.numerator, 1)
            XCTAssertEqual(num.denominator, 1)
        }
        
        let result7 = fractionCal.convertInputAndPerformCalculations(inputString: "? 8/3 / 5/6")
        if case let .success((num, _)) = result7 {
            XCTAssertEqual(num.wholePart, 3)
            XCTAssertEqual(num.numerator, 1)
            XCTAssertEqual(num.denominator, 5)
        }
        
        let result8 = fractionCal.convertInputAndPerformCalculations(inputString: "? -3/4 + -5/6")
        if case let .success((num, _)) = result8 {
            XCTAssertEqual(num.wholePart, -1)
            XCTAssertEqual(num.numerator, -7)
            XCTAssertEqual(num.denominator, 12)
        }
    }
    
    func testFractionDescription() throws {
        let fraction = Fraction(numerator: 2, denominator: -5)
        XCTAssertEqual(fraction.numerator, -2)
        XCTAssertEqual(fraction.denominator, 5)
        
        let fraction2 = Fraction(numerator: -2, denominator: -5)
        XCTAssertEqual(fraction2.numerator, 2)
        XCTAssertEqual(fraction2.denominator, 5)
    }
    
    func testMixedFractionDescription() throws {
        let mixedNumber = MixedNumber(wholePart: 1, numerator: 5, denominator: 6)
        XCTAssertEqual(mixedNumber.description(), "1&5/6")
        
        let mixedNumber2 = MixedNumber(wholePart: 0, numerator: 5, denominator: 6)
        XCTAssertEqual(mixedNumber2.description(), "5/6")
        
        let mixedNumber3 = MixedNumber(wholePart: 2, numerator: 5, denominator: -6)
        XCTAssertEqual(mixedNumber3.description(), "-2&5/6")
        
        let mixedNumber4 = MixedNumber(wholePart: 2, numerator: -5, denominator: -6)
        XCTAssertEqual(mixedNumber4.description(), "2&5/6")
        
        let mixedNumber5 = MixedNumber(wholePart: 4, numerator: 1, denominator: 1)
        XCTAssertEqual(mixedNumber5.description(), "4")
    }
}
