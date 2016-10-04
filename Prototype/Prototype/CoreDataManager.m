//
//  CoreDataManager.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "CoreDataManager.h"
#import "DataCollector.h"

@implementation CoreDataManager

- (void)saveToCoreDataStorage {
    /*
     Here we create an instance of Storage,
     it's time to fill it with data from
     properties of our Singleton instance
     */
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    WeatherInformation *storage = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherInformation" inManagedObjectContext:_managedObjectContext];
    storage.city = [DataCollector sharedInstance].city;
    storage.address = [DataCollector sharedInstance].address;
    storage.time = [DataCollector sharedInstance].timeOfRequest;
    storage.longitude = [DataCollector sharedInstance].longitude;
    storage.latitude = [DataCollector sharedInstance]. latitude;
    storage.weatherToday = [DataCollector sharedInstance].weatherToday;
    // Saving data
    NSError *error = nil;
    if(![_managedObjectContext save:&error]) {
    }
    NSLog(@"Objects are saved");
}

- (NSMutableArray *)getDataFromCoreDataStorage {
    // Here we return an array, that contain the result of Core Data Storage request
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription *storage = [NSEntityDescription entityForName:@"WeatherInformation" inManagedObjectContext:_managedObjectContext];
    [request setEntity:storage];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error ] mutableCopy];
    if (mutableFetchResults == nil) {
        //handle error
    }
    return mutableFetchResults;
}

@end
