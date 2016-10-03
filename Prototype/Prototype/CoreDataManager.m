//
//  CoreDataManager.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "CoreDataManager.h"
#import "Singleton.h"

@implementation CoreDataManager

-(void)saveToCoreDataStorage{
    /*
     Here we create an instance of Storage-class, 
     and we work with it's context
     */
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    Storage *storage = [NSEntityDescription insertNewObjectForEntityForName:@"Storage" inManagedObjectContext:_managedObjectContext];
    
    storage.city = [Singleton sharedInstance].city;
    storage.address = [Singleton sharedInstance].address;
    storage.time = [Singleton sharedInstance].timeOfRequest;
    storage.longitude = [Singleton sharedInstance].longitude;
    storage.latitude = [Singleton sharedInstance]. latitude;
    storage.weatherToday = [Singleton sharedInstance].weatherToday;
    
    //Saving data
    NSError *error = nil;
    if(![_managedObjectContext save:&error]){
    }
    NSLog(@"Objects are saved");
}

-(NSMutableArray *)getDataFromCoreDataStorage{
    /*
     Here we return an array, that contain the result of Core Data Storage request
     */
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription *storage = [NSEntityDescription entityForName:@"Storage" inManagedObjectContext:_managedObjectContext];
    
    [request setEntity:storage];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error ] mutableCopy];
    
    if (mutableFetchResults == nil){
        //handle error
    }
        
    return mutableFetchResults;
}

@end
