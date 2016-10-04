//
//  Storage+CoreDataProperties.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/3/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherInformation+CoreDataProperties.h"

@implementation WeatherInformation (CoreDataProperties)

@dynamic city;
@dynamic address;
@dynamic time;
@dynamic longitude;
@dynamic latitude;
@dynamic weatherToday;

@end
