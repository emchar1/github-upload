//
//  CarsViewController.swift
//  Cool Cars
//
//  Created by Eddie Char on 2/11/22.
//

import UIKit

class CarsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CarsDetailControllerDelegate {
    
    // MARK: - Properties    
    let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CarsCell.self, forCellWithReuseIdentifier: CarsCell.reuseID)
        return collectionView
    }()
        
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "lightBlue")
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)])
        
        
        //Personal touch.
        if K.name == nil {
            let alertController = UIAlertController(title: "Hello!", message: "What's your name?", preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Enter First Name"
                textField.autocapitalizationType = .words
            }
            
            let okAction = UIAlertAction(title: "Continue", style: .default) { _ in
                guard let textFields = alertController.textFields else { return }
                
                let name = textFields[0].text!.count > 0 ? textFields[0].text : "You"
                K.name = name
                
                UserDefaults.standard.set(name, forKey: "Name")
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true)
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetails" {
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! CarsDetailController
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                controller.carModel = K.carModels[indexPath.row]
                controller.delegate = self
                
                if K.carModels[K.selectedCarIndex] == K.carModels[indexPath.row] {
                    controller.isCurrentCar = true
                }
            }
        }
    }
    
}


// MARK: - Collection View

extension CarsViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.carModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarsCell.reuseID, for: indexPath) as! CarsCell
        
        cell.carModel = K.carModels[indexPath.row]
        cell.setSelected(indexPath.row == K.selectedCarIndex ? true : false)
        cell.setMileageView(carModel: K.carModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let width = view.bounds.width - 2 * padding
        let height = width * 2 / 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CarsCell
        cell.setShadow(pressed: true)
    
        performSegue(withIdentifier: "segueDetails", sender: nil)
    }
}


// MARK: - CarsDetailControllerDelegate

extension CarsViewController {
    func didSelectCar(_ car: CarModel) {
        for (i, carModel) in K.carModels.enumerated() {
            if carModel == car {                
                if carModel.make == "Ghostbusters" {
                    AudioPlayer.playSound(filename: "ghostbusters_sms")
                }

                K.selectedCarIndex = i
                let mileageUsed = Int.random(in: 2...100)
                K.carModels[K.selectedCarIndex].milesThisMonth += mileageUsed
                
                UserDefaults.standard.set(i, forKey: "SelectedCarIndex")
                
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(K.carModels)
                    UserDefaults.standard.set(data, forKey: "CarModels")
                }
                catch {
                    print("Error saving to User Defaults.")
                }
                
                collectionView.reloadData()
                showMileageUsed(mileageUsed)
                
                break
            }
        }
    }

    private func showMileageUsed(_ mileageUsed: Int) {
        let cellPadding: CGFloat = 8
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let popupView = UIView()
        popupView.backgroundColor = .systemBlue
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.layer.cornerRadius = 8
        popupView.clipsToBounds = true
        popupView.alpha = 0.95
        popupView.isUserInteractionEnabled = false
        
        let label = UILabel()
        label.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
        label.textColor = .white
        label.text = "\(K.name ?? "Eddie") drove \(mileageUsed) miles in the \(K.carModels[K.selectedCarIndex].make).\nMiles driven: \(numberFormatter.string(from: NSNumber(value:  K.carModels[K.selectedCarIndex].milesThisMonth)) ?? "0")/2,000."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(label)
        
        view.addSubview(popupView)
        NSLayoutConstraint.activate([popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     view.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: 20),
                                     popupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: popupView.topAnchor, constant: cellPadding),
                                     label.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: cellPadding),
                                     popupView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: cellPadding),
                                     popupView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: cellPadding)])
        
        UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseInOut) {
            popupView.alpha = 0
        } completion: { _ in
            popupView.removeFromSuperview()
        }

    }
}
