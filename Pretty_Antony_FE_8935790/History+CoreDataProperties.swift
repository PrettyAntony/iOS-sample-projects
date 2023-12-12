//
//  History+CoreDataProperties.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/10/23.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var dateTime: String?
    @NSManaged public var totalDistance: String?
    @NSManaged public var endPlace: String?
    @NSManaged public var humidity: String?
    @NSManaged public var id: UUID?
    @NSManaged public var modeOfTransport: String?
    @NSManaged public var newsAuthor: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var newsSource: String?
    @NSManaged public var newsTitle: String?
    @NSManaged public var sourceOfTransaction: String?
    @NSManaged public var startPlace: String?
    @NSManaged public var temperature: String?
    @NSManaged public var typeOfTransaction: String?
    @NSManaged public var wind: String?

}

extension History : Identifiable {

}
