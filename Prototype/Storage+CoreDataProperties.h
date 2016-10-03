//
//  Storage+CoreDataProperties.h
//  Prototype
//
//  Created by Uri Fuholichev on 10/3/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Storage.h"

NS_ASSUME_NONNULL_BEGIN

@interface Storage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *weatherToday;

@end

NS_ASSUME_NONNULL_END
