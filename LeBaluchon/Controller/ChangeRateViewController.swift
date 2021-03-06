//
//  ChangeRateViewController.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 09/03/2022.
//

import UIKit

class ChangeRateViewController: UIViewController {
    // list of different outlets
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var textViewUser: UITextView!
    @IBOutlet weak var textViewResult: UITextView!
    @IBOutlet weak var doneRateButton: UIButton!
    @IBOutlet weak var deleteUserValueButton: UIButton!
    @IBOutlet weak var dollarRateView: UIView!
    @IBOutlet weak var rateUpdateLabel: UILabel!
    @IBOutlet weak var updatedDateDisplayLabel: UILabel!
    
    // date and result formatting
    private var numberFormatter = NumberFormatter()
    private let dateFormatter = DateFormatter()
        
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        donateLatestRate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(view: frameView)
        setupView(view: dollarRateView)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textViewUser.resignFirstResponder()
    }
    
    @IBAction func tappedDoneRateButton() {
        let userValueString = textViewUser.text
        // condition if the value in euro is empty
        guard userValueString != "" else {
            self.presentAlert(message: "Saisissez une valeur")
            return
        }
        guard let userValue = Float(userValueString!) else {
            self.presentAlert(message: "Saisissez un nombre")
            return
        }
        guard let convertedValue = ChangeService.shared.calculation(value: userValue) else { return }
        textViewUser.resignFirstResponder()
        decimalNumber()
        let formattedValue = NSNumber(value: convertedValue)
        let resultValue = numberFormatter.string(from: formattedValue) ?? ""
        self.textViewResult.text = resultValue
    }
    
    @IBAction func deleteUserValue(_ sender: Any) {
        textViewUser.text.removeAll()
    }
    private func donateLatestRate() {
        ChangeService.shared.fetchCurrentRate { rate, date in
            guard let rate = rate else {
                self.presentAlert(message: "Le t??l??chargement des donn??es a ??chou??.")
                return
            }
            self.update(rate: rate, date: date)
        }
    }
    
    private func update(rate: Float, date: Date) {
        rateUpdateLabel.text = "1 EUR = \(rate) USD"
        formatDate()
        updatedDateDisplayLabel.text = "Taux actualis?? le : \(dateFormatter.string(from: date))"
    }
}

extension ChangeRateViewController {
    private func setupView(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
    }
    
    private func formatDate() {
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "FR-fr")
    }
    
    private func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    func decimalNumber() {
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: "US-us")
        numberFormatter.numberStyle = .currency
    }
}
