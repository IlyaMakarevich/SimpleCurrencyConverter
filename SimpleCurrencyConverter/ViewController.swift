//
//  ViewController.swift
//  SimpleCurrencyConverter
//
//  Created by Ilya Makarevich on 2.10.23.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private var pickerFrom: UIPickerView!
    @IBOutlet private var pickerTo: UIPickerView!
    @IBOutlet private var amountTextField: UITextField!
    @IBOutlet private var convertButton: UIButton!
    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet private var addToFavoritesButton: UIButton!
    @IBOutlet private var removeFromFavoritesButton: UIButton!
    @IBOutlet private var showAllButton: UIButton!
    @IBOutlet private var showFavoritesButton: UIButton!
    
    private let apiService = APIService()
    private let persistanceService = PersistanceService()
    private var currentlyPickedFromSymbol: CurrencyItem = .init(code: "", value: "")
    private var currentlyPickedToSymbol: CurrencyItem = .init(code: "", value: "")
    private var serverSymbols = [CurrencyItem]()
    private var favoriteSymbols = [CurrencyItem]()
    
    private var isFavoriteShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        resultLabel.text = ""
        
        pickerFrom.dataSource = self
        pickerTo.dataSource = self
        
        pickerFrom.delegate = self
        pickerTo.delegate = self
        
        apiService.loadSymbols { [weak self] resultBool, result, timeInterval in
        
            self?.serverSymbols = result.map {
                return .init(code: $0.key, value: $0.value)
            }.sorted(by: { $0.code < $1.code })
            
            DispatchQueue.main.async {
                self?.reloadPickers()
                if let first = self?.serverSymbols[safe: 0] {
                    self?.currentlyPickedFromSymbol = first
                    self?.currentlyPickedToSymbol = first
                }
                self?.updateButtonsState()
            }
        }
    }

    @IBAction private func convertButtonAction(_ sender: Any) {
        dismissKeyboard()
        

        guard let enteredValue = amountTextField.text else {
            return
        }
        let symbols = serverSymbols.map {
            return $0.code
        }.joined(separator: ",")
        
        apiService.loadRates(base: currentlyPickedFromSymbol.code,
                             symbols: symbols) { [weak self] boolResult, result, timeInterval in
            guard boolResult == true, let toValue = self?.currentlyPickedToSymbol, let fromValue = self?.currentlyPickedToSymbol else {
                // handle error
                return
            }
            
            guard let toRate = result[toValue.code] else {
                // handle error
                return
            }
            
            let result = enteredValue + " " + fromValue.value + " equals to: " + String(toRate) + " " + toValue.value
            
            DispatchQueue.main.async {
                self?.resultLabel.text = result
            }
        }
    }
    
    @IBAction private func addToFavoritesAction(_ sender: Any) {
        persistanceService.saveSymbols(from: currentlyPickedFromSymbol,
                                       to: currentlyPickedToSymbol)
        updateButtonsState()
    }
    
    @IBAction private func removeFromFavorites(_ sender: Any) {
        persistanceService.removeSymbols(from: currentlyPickedFromSymbol,
                                         to: currentlyPickedToSymbol)
        favoriteSymbols = persistanceService.getSymbols()
        isFavoriteShowing = !favoriteSymbols.isEmpty
        updateButtonsState()
        reloadPickers()
        if let first = favoriteSymbols[safe: 0] {
            currentlyPickedFromSymbol = first
            currentlyPickedToSymbol = first
        }
        if !isFavoriteShowing {
            showAllAction(self)
        }
    }
    
    @IBAction private func showAllAction(_ sender: Any) {
        currentlyPickedFromSymbol = serverSymbols[0]
        currentlyPickedToSymbol = serverSymbols[0]
        isFavoriteShowing = false
        reloadPickers()
        if let first = serverSymbols[safe: 0] {
            currentlyPickedFromSymbol = first
            currentlyPickedToSymbol = first
        }
        updateButtonsState()
    }
    
    @IBAction private func showFavoritesAction(_ sender: Any) {
        isFavoriteShowing = true
        let favorites = persistanceService.getSymbols()
        self.favoriteSymbols = favorites
        reloadPickers()
        if let first = favoriteSymbols[safe: 0] {
            currentlyPickedFromSymbol = first
            currentlyPickedToSymbol = first
        }
        updateButtonsState()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

private extension ViewController {
    private func reloadPickers() {
        pickerFrom.reloadAllComponents()
        pickerTo.reloadAllComponents()
        pickerFrom.selectRow(0, inComponent: 0, animated: true)
        pickerTo.selectRow(0, inComponent: 0, animated: true)
    }
    
    private func updateButtonsState() {
        showAllButton.isEnabled = isFavoriteShowing
        showFavoritesButton.isEnabled = !isFavoriteShowing && !persistanceService.getSymbols().isEmpty
        addToFavoritesButton.isEnabled = !isFavoriteShowing
        removeFromFavoritesButton.isEnabled = isFavoriteShowing
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isFavoriteShowing ? favoriteSymbols.count : serverSymbols.count
    }
}


extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isFavoriteShowing {
            return favoriteSymbols[row].code
        } else {
            return serverSymbols[row].code
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            currentlyPickedToSymbol = isFavoriteShowing ? favoriteSymbols[row]: serverSymbols[row]
        } else {
            currentlyPickedFromSymbol = isFavoriteShowing ? favoriteSymbols[row]: serverSymbols[row]
        }
    }
}


extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


