//
//  AppDelegate.swift
//  Cool Cars
//
//  Created by Eddie Char on 2/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Important initialization
        if let data = UserDefaults.standard.data(forKey: "CarModels") {
            print("Found CarModels in User Defaults!")
            do {
                let decoder = JSONDecoder()
                K.carModels = try decoder.decode([CarModel].self, from: data)
            }
            catch {
                print("Error decoding carModels.")
            }
        }
        else {
            print("Didn't find CarModels in User Defaults. Creating now...")
            let cars = getCSVData(file: "cars", ext: "csv")
            for i in 1..<cars.count {
                K.carModels.append(CarModel(make: cars[i][0],
                                            model: cars[i][1],
                                            year: Int(cars[i][2]) ?? 0,
                                            mpgCity: Double(cars[i][3]) ?? 0,
                                            mpgHighway: Double(cars[i][4]) ?? 0,
                                            hp: Int(cars[i][5]) ?? 0,
                                            zeroToSixty: Double(cars[i][6]) ?? 0,
                                            imageName: cars[i][7],
                                            imageFacing: cars[i][8] == "right" ? .right : .left,
                                            milesThisMonth: Int(cars[i][9]) ?? 0))
            }
        }

        K.name = UserDefaults.standard.object(forKey: "Name") as? String
        K.selectedCarIndex = UserDefaults.standard.object(forKey: "SelectedCarIndex") as? Int ?? 1

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

