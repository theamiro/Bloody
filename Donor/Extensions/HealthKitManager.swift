//
//  HealthKitManager.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import HealthKit

class HealthKitManager {
    
    class var sharedInstance: HealthKitManager {
        struct Singleton {
            static let instance = HealthKitManager()
        }
        
        return Singleton.instance
    }
    
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    let dateOfBirthCharacteristic = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)
    
    let bloodTypeCharacteristic = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)
    
    let biologicalSexCharacteristic = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
    
    let weightSample = HKObjectType.quantityType(forIdentifier: .bodyMass)
    
    let heightSample = HKObjectType.quantityType(forIdentifier: .height)
    
    
    var dateOfBirth: String? {
        if let dateOfBirth = try? healthStore?.dateOfBirthComponents() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let calendar = Calendar.current
            var components = DateComponents()
            components.day = dateOfBirth.day
            components.month = dateOfBirth.month
            components.year = dateOfBirth.year
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let birthday = calendar.date(from: components)
            return dateFormatter.string(from: birthday!)
        }
        return nil
    }
    
    var bloodType: String? {
        if let bloodType = try? healthStore?.bloodType() {
            switch bloodType.bloodType {
            case .aPositive:
                return "A+"
            case .aNegative:
                return "A-"
            case .bPositive:
                return "B+"
            case .bNegative:
                return "B-"
            case .abPositive:
                return "AB+"
            case .abNegative:
                return "AB-"
            case .oPositive:
                return "O+"
            case .oNegative:
                return "O-"
            case .notSet:
                return nil
            @unknown default:
                return nil
            }
        }
        return nil
    }
    
    var biologicalSex: String? {
        if let biologicalSex = try? healthStore?.biologicalSex() {
            switch biologicalSex.biologicalSex {
            case .female:
                return "Female"
            case .male:
                return "Male"
            case .notSet:
                return nil
            case .other:
                return "undefined"
            @unknown default:
                return nil
            }
        }
        return nil
    }
    class func getMostRecentSample(for sampleType: HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            //2. Always dispatch to the main thread when complete.
            DispatchQueue.main.async {
                guard let samples = samples,
                    let mostRecentSample = samples.first as? HKQuantitySample else {
                        
                        completion(nil, error)
                        return
                }
                completion(mostRecentSample, nil)
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    func requestHealthKitAuthorization(dataTypesToWrite: NSSet?, dataTypesToRead: NSSet?, completion: @escaping (Bool, Error?) -> Void) {
        healthStore!.requestAuthorization(toShare: nil, read: (dataTypesToRead as! Set<HKObjectType>),                                   completion: { (success, error) -> Void in
            if success {
                print("successfully accessed HealthKit Data")
                completion(success, nil)
            } else {
                print(error?.localizedDescription)
            }
        })
    }
}
