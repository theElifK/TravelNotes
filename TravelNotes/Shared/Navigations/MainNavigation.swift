//
//  MainNavigation.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 25.12.2023.
//

import UIKit


class MainNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let topBarHeight = statusBarHeight +
                (self.navigationBar.frame.height)
            Constants.NavHeight = Float(topBarHeight)
        }
        NavAppearnce()
    }
    

    
    func NavAppearnce() {
      
        let tintColor : UIColor = .black
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: tintColor]
            navBarAppearance.backgroundColor = .clear
            navBarAppearance.shadowColor = .clear
            self.navigationBar.tintColor = tintColor
            self.navigationBar.isTranslucent = true
            UINavigationBar.appearance().barTintColor = .clear
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.standardAppearance = navBarAppearance
            self.navigationBar.compactAppearance = navBarAppearance
            self.navigationBar.scrollEdgeAppearance = navBarAppearance
         
        }
        
 
    }

}
