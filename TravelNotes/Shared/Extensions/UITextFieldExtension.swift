//
//  UITextFieldExtension.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 28.01.2024.
//

import Foundation
import UIKit

extension UITextField{
    func datePickerTime<T>(target: T,
                           doneAction: Selector,
                           cancelAction: Selector,
                           datePickerMode: UIDatePicker.Mode = .time) {
            let screenWidth = UIScreen.main.bounds.width
            
            func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
                let buttonTarget = style == .flexibleSpace ? nil : target
                let action: Selector? = {
                    switch style {
                    case .done:
                        return doneAction
                    default:
                        return nil
                    }
                }()
                
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                    target: buttonTarget,
                                                    action: action)
               // let barButtonItem = UIBarButtonItem(title: "Done".localized, style: .done, target: buttonTarget, action: action)
                
                return barButtonItem
            }
            
            let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: screenWidth,
                                                        height: 216))
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            datePicker.datePickerMode = .time
            datePicker.setValue(UIColor.black, forKey: "textColor")
            datePicker.locale =  NSLocale.init(localeIdentifier: "tr_TR") as Locale
            self.inputView = datePicker
            
            let toolBar = UIToolbar(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: screenWidth,
                                                  height: 44))
            toolBar.setItems([buttonItem(withSystemItemStyle: .flexibleSpace),
                              buttonItem(withSystemItemStyle: .done)],
                             animated: true)
            toolBar.tintColor = .black
            self.inputAccessoryView = toolBar
        }
    
    func datePicker<T>(target: T,
                           doneAction: Selector,
                           cancelAction: Selector,
                           datePickerMode: UIDatePicker.Mode = .date) {
            let screenWidth = UIScreen.main.bounds.width
            
            func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
                let buttonTarget = style == .flexibleSpace ? nil : target
                let action: Selector? = {
                    switch style {
                    case .done:
                        return doneAction
                    default:
                        return nil
                    }
                }()
                
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                    target: buttonTarget,
                                                    action: action)
                return barButtonItem
            }
            
            let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: screenWidth,
                                                        height: 216))
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
           // datePicker.minimumDate = Date()
            datePicker.datePickerMode = .date
            datePicker.setValue(UIColor.black, forKey: "textColor")
            datePicker.locale =  NSLocale.init(localeIdentifier: "tr_TR") as Locale
            self.inputView = datePicker
            
            let toolBar = UIToolbar(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: screenWidth,
                                                  height: 44))
            toolBar.setItems([buttonItem(withSystemItemStyle: .flexibleSpace),
                              buttonItem(withSystemItemStyle: .done)],
                             animated: true)
            toolBar.tintColor = .black
            self.inputAccessoryView = toolBar
        }
}
