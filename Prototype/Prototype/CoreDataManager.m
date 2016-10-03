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
     Данный метод создает экземпляр хранилища, открывает контекст для него
     и кидает экземпляр с открытым контекстом внутрь массива
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
    
    //And let's free all properties of SingletonObject
    [Singleton sharedInstance].latitude = nil;
    [Singleton sharedInstance].longitude = nil;
    [Singleton sharedInstance].address = nil;
    [Singleton sharedInstance].city = nil;
    [Singleton sharedInstance].zipcode = nil;
    [Singleton sharedInstance].weatherToday = nil;
    [Singleton sharedInstance].weatherToday = nil;
    [Singleton sharedInstance].weatherTomorrow = nil;

    
    //ЭТО СОХРАНЯЕТ ЗНАЧЕНИЕ КОНТЕКСТА в базу Core Data
    NSError *error = nil;
    if(![_managedObjectContext save:&error]){
    }
    NSLog(@"Objects are saved?");
}

-(NSMutableArray *)getDataFromCoreDataStorage{
    
    //данный метод вызывает в массив значения из базы CoreData
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
    
    NSLog(@"fetch request array contain %lu", [mutableFetchResults count]);
    
//    NSMutableArray *arrayWithData = [NSMutableArray new];
//    
//    [arrayWithData arrayByAddingObjectsFromArray:mutableFetchResults];
    
//    return arrayWithData;
    return mutableFetchResults;
}

@end
