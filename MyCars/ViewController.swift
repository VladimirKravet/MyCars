//
//  ViewController.swift
//  MyCars
//
//  Created by Vladimir Kravets on 23.10.2022.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    lazy var dateFormator: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()
    
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var markLabel: UILabel!
    
    @IBOutlet weak var modelLabel: UILabel!
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    private func insertDataFrom(selectedCar car: Car) {
        
        carImageView.image = UIImage(data: car.imageData!)
        markLabel.text = car.mark
        modelLabel.text = car.model
        myChoiceImageView.isHidden = !(car.myChoice)
        ratingLabel.text = "Rating: \(car.rating) / 10"
        numberOfTripsLabel.text = "Number of trips: \(car.timesDriven)"
        lastTimeStartedLabel.text = "Last time started: \(dateFormator.string(from: car.lastStarted!))"
        segmentedControl.tintColor = car.tintColor as? UIColor
        
    }
    
    
    //MARK: -func add data.plist in app
    private func getDataFromFile() {

        
        //MARK: -check all records type Car in CoreData
//        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "mark != nil")
//
//        var records = 0
//
//        do {
//            records = try context.count(for: fetchRequest)
//            print("Is Data there already ?")
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        guard records == 0 else {return print("Is empty")}
//        print("Data there")
        
        
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
            car.imageData = imageData
            
            //MARK: - tintColor
            if let colorDictionary = carDictionary["tintColor"] as? [String : Float] {
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
    }
        do {
            try context.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
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
        
        //MARK: -first start and only one save getDataFromFile() in CoreData
        if defaults.bool(forKey: "First Lunch") == true {
            print("Second")
            chooseSegment()
            defaults.set(true, forKey: "First Lunch")
        } else {
            print("First session")
            getDataFromFile()
            chooseSegment()
            defaults.set(true, forKey: "First Lunch")
        }
        

       //MARK: -make choose that show on segmentedControl at first VC
        func chooseSegment() {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        let mark = segmentedControl.titleForSegment(at: 0)
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        do {
            let results = try context.fetch(fetchRequest)
            let selectedCar = results.first
            insertDataFrom(selectedCar: selectedCar!)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    }
    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
    }
    
    
    @IBAction func rateItPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
                print("delete")
            }
            
        }
        do {
            try context.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
   }
}

