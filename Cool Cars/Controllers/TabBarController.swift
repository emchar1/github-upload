//
//  TabBarController.swift
//  Cool Cars
//
//  Created by Eddie Char on 2/15/22.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self        
    }
        
    //Need to programatically set the current car selection if tabbing over from the car selection tab.
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vc = tabBarController.viewControllers, let controller = vc[0] as? CarsDetailController {
            controller.carModel = K.carModels[K.selectedCarIndex]
        }
    }
}
