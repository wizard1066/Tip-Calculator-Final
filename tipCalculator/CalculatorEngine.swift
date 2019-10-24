/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

struct CalculatorEngine {
  private var billValue: Double?
  private var percentValue: Double?
  private var payerValue: Double?
  
  init(bill: String, cent: String) {
    billValue = Double(bill)
    percentValue = Double(cent)
  }

  mutating func setBillValue(to valueSet: String) {
    billValue = Double(valueSet)
  }
  
  mutating func setTipCent(to valueSet: String) {
    percentValue = Double(valueSet)
  }

  func calcValues() throws -> (youTip: Double, youPay: Double) {
      guard let _ = billValue,
            let _ = percentValue
      else {
        throw "nil"
      }
      let tipToPay = (billValue! * percentValue! / 100).roundToDecimal(places: 2)
      return (tipToPay, billValue! + tipToPay)
      }
  }

// MARK: Needed to present ugly recurive numbers like 1.333333

extension Double {
  func roundToDecimal(places fractionDigits: Int) -> Double {
    let multiplier = pow(10, Double(fractionDigits))
    return Darwin.round(self * multiplier) / multiplier
  }
}

// MARK:  Needed to facilitate means of throwing a simple error message

extension String: Error {}
