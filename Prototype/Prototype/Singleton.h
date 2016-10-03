//
//  Singletone.h
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 This class (its' properties) is used to collect and store temporary all key values (location + weather + time of request) before passing them to Core Data store
 */

@interface Singleton : NSObject

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;   //And city  will be stored separately
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *weatherToday;
@property (strong, nonatomic) NSString *weatherTomorrow;
@property (strong, nonatomic) NSString *timeOfRequest;

+(Singleton *)sharedInstance;

@end
