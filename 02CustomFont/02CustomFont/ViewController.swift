//
//  ViewController.swift
//  02CustomFont
//
//  Created by 沈翔 on 2019/11/22.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var fontPicker: UIPickerView!
    
    lazy var fonts = {
        return UIFont.familyNames.sorted()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontPicker.delegate = self
    }

}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fonts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fonts[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textLabel.font = UIFont(name: fonts[row], size: 30)
        textLabel.text = fonts[row]
    }
}
