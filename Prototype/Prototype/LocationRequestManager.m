//
//  CurrentLocation.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "LocationRequestManager.h"
#import "DataCollector.h"
#import "WeatherRequestManager.h"

@implementation LocationRequestManager {
    CLLocationManager *locationManager;
    // These 2 instances to encode geodata to address
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)getCurrentLocation {
    locationManager = [[CLLocationManager alloc] init];
    // Here we encode geodata
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // This is required to make the simulator enable to simulate location
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

// To handle errors we use this
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

// Key delegate method for CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    // Here we get the last point from array of points (of visited locations)
    CLLocation *crnLoc = [locations lastObject];
    // To save device's battery let's stop updatingLocation
    [locationManager stopUpdatingLocation];
    // Here we convert coordinates to real address and store it's values at Singleton object inside block
    [geocoder reverseGeocodeLocation:crnLoc completionHandler:^(NSArray *placemarks, NSError *error) {
         if (error == nil && [placemarks count] > 0) {
             placemark = [placemarks lastObject];
             // Country, region, city, street, house
             [DataCollector sharedInstance].address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",
                             placemark.country,
                             placemark.administrativeArea,
                             placemark.locality,
                             placemark.thoroughfare,
                             placemark.subThoroughfare];
             
             [DataCollector sharedInstance].city = placemark.locality;
             [DataCollector sharedInstance].zipcode = placemark.postalCode;
             [DataCollector sharedInstance].longitude = [NSString stringWithFormat:@"%.6f", crnLoc.coordinate.longitude];
             [DataCollector sharedInstance].latitude = [NSString stringWithFormat:@"%.6f", crnLoc.coordinate.latitude];
             // When Singleton object has all address data, we will fire new method to collect weather data
             if([DataCollector sharedInstance].address)
                 [self performSelectorOnMainThread:@selector(requestWeather) withObject:nil waitUntilDone:YES];
         } else {
             NSLog(@"%@", error.debugDescription);
         }
     }];
}

- (void)requestWeather {
    NSLog(@"zip: %@, lat: %@, long: %@, address: %@", [DataCollector sharedInstance].zipcode, [DataCollector sharedInstance].latitude, [DataCollector sharedInstance].longitude, [DataCollector sharedInstance].address);
    WeatherRequestManager *weather = [WeatherRequestManager new];
    [weather getWeather];
}

@end

