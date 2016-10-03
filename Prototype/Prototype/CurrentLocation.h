//
//  CurrentLocation.h
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocation : NSObject <CLLocationManagerDelegate>

/*
 To have the ability to simulate locations
 it necesary to add 2 Strings to plist:
 NSLocationAlwaysUsageDescription
 NSLocationWhenInUseUsageDescription
 */
-(void)getCurrentLocation;

@end
