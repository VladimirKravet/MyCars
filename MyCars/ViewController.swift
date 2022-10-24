//
//  ViewController.swift
//  MyCars
//
//  Created by Vladimir Kravets on 23.10.2022.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    
    var context: NSManagedObjectContext!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var markLabel: UILabel!
    
    @IBOutlet weak var modelLabel: UILabel!
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    
    //MARK: -func add data.plist in app
    private func getDataFromFile() {
        guard let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist"),
                let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
        
        //MARK: -extract dictionary from data.plist
        for dictionary in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: context) else {return}
            
            let car = NSManagedObject(entity: entity, insertInto: context) as! Car
            
            let carDictionary = dictionary as! [String : AnyObject]
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as! Int16
            car.myChoice = carDictionary["myChoice"] as! Bool
            
            //MARK: -working with image
            guard let imageName = carDictionary["imageName"] as? String,
                let image = UIImage(named: imageName) else {return}
            let imageData = image.pngData()
            car.imageData = imageData as? Data
            
            //MARK: - tintColor
            if let colorDictionary = carDictionary["tintColor"] as? [String : Float] {
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
        }
    }
    //MARK: get color
    private func getColor(colorDictionary: [String : Float]) -> UIColor {
        guard let red = colorDictionary["red"],
              let green = colorDictionary["green"],
              let blue = colorDictionary["blue"] else {return UIColor()}
        return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //MARK: -How to check if the IOS app is running for the first time using SWIFT
        if (UserDefaults.standard.bool(forKey: "HasLaunchedOne")) {
        print("HasLaunchedOne")
        } else {
            UserDefaults.standard.set(true, forKey: "HasLaunchedOne")
            UserDefaults.standard.synchronize()
            getDataFromFile()
            print("First Launch")
        }
    }
    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
    }
    
    
    @IBAction func rateItPressed(_ sender: UIButton) {
    }
    
    
}

