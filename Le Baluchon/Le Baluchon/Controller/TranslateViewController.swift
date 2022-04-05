//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 09/03/2022.
//

import UIKit

class TranslateViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textToTranslateTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var resultOfTranslateTextView: UITextView!
    @IBOutlet weak var changeLangageButton: UIButton!
    @IBOutlet weak var langageToTranslateLabel: UILabel!
    @IBOutlet weak var langageTranslatedLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var clearTextButton: UIButton!
    
    var placeholderLabel: UILabel!
    let translate = TranslateService()
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        setupPlaceholderLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIViewController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: UIViewController.keyboardWillHideNotification, object: nil)
        
        textToTranslateTextView.delegate = self
        placeholderLabel = UILabel()
        toggleActivityIndicator(shown: false)
    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc func keyboardAppear(_ notification: Notification) {
        clearTextButton.isHidden = false
    }
    
    @objc func keyboardDisappear(_ notification: Notification) {
        clearTextButton.isHidden = true
    }
    
    @IBAction func changeLangage() {
        changeLangageButton.isSelected = !changeLangageButton.isSelected
        guard changeLangageButton.isSelected == true else {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.9, options: [], animations: {
                self.changeLangageButton.transform = .identity
            }, completion: nil)
            clearText()
            setupPlaceholderLabel()
            translate.changeLangage(source: "fr", target: "en")
            langageToTranslateLabel.text = "Français"
            langageTranslatedLabel.text = "Anglais"
            return
        }
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.9, options: [], animations: {
            self.changeLangageButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }, completion: nil)
        clearText()
        setupPlaceholderLabel()
        translate.changeLangage(source: "en", target: "fr")
        langageToTranslateLabel.text = "Anglais"
        langageTranslatedLabel.text = "Français"
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslateTextView.resignFirstResponder()
    }
    
    @IBAction func deleteTextToTranslate () {
        textToTranslateTextView.text = ""
        setupPlaceholderLabel()
    }
    
    @IBAction func tappedTranslate() {
        textToTranslateTextView.resignFirstResponder()
        toggleActivityIndicator(shown: true)
        translate.changeTextUser(text: "\(textToTranslateTextView.text!)")
        if textToTranslateTextView.text == "" {
            self.presentAlert(message: "Veuillez saisir du texte")
            toggleActivityIndicator(shown: false)
        } else {
            TranslateService.shared.getValue { success, data in
                self.toggleActivityIndicator(shown: false)
                guard success, let translate = data else {
                    self.presentAlert(message: "Le téléchargement des données a échoué.")
                    return
                }
                self.update(textTranslated: translate)
            }
        }
        
    }
    
    private func update(textTranslated: Translate) {
        guard let translate = textTranslated.data.translations.first?.translatedText else {
            resultOfTranslateTextView.text = nil
            return
        }
        resultOfTranslateTextView.text = translate
    }
    
    private func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func clearText() {
        resultOfTranslateTextView.text = ""
        textToTranslateTextView.text = ""
    }
    
    private func setupPlaceholderLabel() {
        placeholderLabel.text = "Saisissez votre message"
        placeholderLabel.font = UIFont.boldSystemFont(ofSize: (textToTranslateTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textToTranslateTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textToTranslateTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.systemGray3
        placeholderLabel.isHidden = !textToTranslateTextView.text.isEmpty
    }
}
