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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func convertButtonAction(_ sender: Any) {
    }
    
    @IBAction private func addToFavoritesAction(_ sender: Any) {
    }
    
    @IBAction private func removeFromFavorites(_ sender: Any) {
    }
    
    @IBAction private func showAllAction(_ sender: Any) {
    }
    
    @IBAction private func showFavoritesAction(_ sender: Any) {
    }
    
}

