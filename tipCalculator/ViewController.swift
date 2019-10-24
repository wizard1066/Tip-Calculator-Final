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

import UIKit

class ViewController: UIViewController {


  private var firstCall: Bool = true

  private enum DefaultValues {
   static let standardCent = 15
   static let initialBill = 0
  }
  
  private enum Tags: Int {
    case bill
    case percent
    case payers
  }
  
  @IBOutlet weak var outerStackView: UIStackView!

  @IBOutlet weak var bill: UITextField!
  @IBOutlet weak var percent: UITextField!
  @IBOutlet weak var youTip: UILabel!
  @IBOutlet weak var youPay: UILabel!
  @IBOutlet weak var percentValue: UIStepper!
  
  private var engine: CalculatorEngine = CalculatorEngine(bill: DefaultValues.initialBill.description,
    cent: DefaultValues.standardCent.description)
  
    @IBAction func percentStepper(_ sender: UIStepper) {
  
    setValues(tag: Tags.percent.rawValue, text: percentValue.value.description)
    percent.text = ("\(Int(percentValue.value))")
  
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLabelsAndText()
    autoLayoutRules()
  }
  
  func setupLabelsAndText() {
  // Normally thse would be set, but in this demo project they are not initially
    guard let _ = bill,
           let _ = percent
    else {
      return
    }
    bill.tag = Tags.bill.rawValue
    percent.tag = Tags.percent.rawValue
    bill.delegate = self
    percent.delegate = self
    
    percentValue.value = Double(DefaultValues.standardCent)
    percent.text = "\(DefaultValues.standardCent)"
  }
  
  var topYConstraint: NSLayoutConstraint?
  var centerYConstraint: NSLayoutConstraint?
  
  func autoLayoutRules() {
    // 1
    outerStackView.translatesAutoresizingMaskIntoConstraints = false
    let margins = view.layoutMarginsGuide
    // 2
    topYConstraint = outerStackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8)
    centerYConstraint = outerStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    centerYConstraint?.isActive = true
    let centerXConstraint =
      outerStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
    centerXConstraint.isActive = true
  }
  
  // 1
  private enum KBAction {
    static let kwsn = UIResponder.keyboardWillShowNotification
    static let kwhn = UIResponder.keyboardWillHideNotification
  }
  
  // 2
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self,
          selector: #selector(keyboardWillShow),
          name: KBAction.kwsn, object: nil)
    NotificationCenter.default.addObserver(self,
          selector: #selector(keyboardWillHide),
          name: KBAction.kwhn, object: nil)
  }
  
  // 3
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(KBAction.kwsn)
    NotificationCenter.default.removeObserver(KBAction.kwhn)
  }
  
  // 4
  @objc func keyboardWillShow(notification: NSNotification) {
    centerYConstraint?.isActive = false
    topYConstraint?.isActive = true
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    topYConstraint?.isActive = false
    centerYConstraint?.isActive = true
  }
}

// MARK: UITextField delegate validates and transfers data to the UI/Model

extension ViewController: UITextFieldDelegate {
  
  func setValues(tag: Int, text: String) {
  // 1
    switch tag {
    case Tags.bill.rawValue: engine.setBillValue(to: text)
    case Tags.percent.rawValue: engine.setTipCent(to: text)
    default:
      break
    }
    do {
      let (totalTip, totalBill) = try engine.calcValues()
      youPay.text = totalBill.description
      youTip.text = totalTip.description
    } catch {
    // 2
      let alert = UIAlertController(title: "Error",
                message: "Sorry, must be a number",
                preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok",
                                style: .default,
                                handler: { (action) in
        self.firstCall = true
      }))
      // 3
      if firstCall {
        // UITextField Delegate is called twice, but we only need to present a single alert
        self.present(alert, animated: true)
        firstCall = false
      }
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    setValues(tag: textField.tag, text: textField.text!)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      textField.resignFirstResponder()
      return false
    }
    return true
  }
}

