//
//  CurrentLocation.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "CurrentLocation.h"
#import "Singleton.h"
#import "CurrentWeather.h"

@interface CurrentLocation()

@property(strong, nonatomic)CurrentWeather *currentWeather;

@end

@implementation CurrentLocation
{
    CLLocationManager *locationManager;
    
    //these next 2 values to encode geodata to address
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

-(void)getCurrentLocation{
    
    locationManager = [[CLLocationManager alloc] init];
    
    //here we encode geodata
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //this to make the simulator enable to simulate location
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

//To handle errors
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

//Key delegate method for CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    //here we get the last point from array of points
    CLLocation *crnLoc = [locations lastObject];
    
    //to save battery let's stop updating
    [locationManager stopUpdatingLocation];
        
    //Here we convert coordinates to real address and store it's values at Singleton object
    [geocoder reverseGeocodeLocation:crnLoc completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0) {
             placemark = [placemarks lastObject];
             
             //country, region, city, street, house
             [Singleton sharedInstance].address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",
                             placemark.country,
                             placemark.administrativeArea,
                             placemark.locality,
                             placemark.thoroughfare,
                             placemark.subThoroughfare];
             
             [Singleton sharedInstance].city = placemark.locality;
             [Singleton sharedInstance].zipcode = placemark.postalCode;
             [Singleton sharedInstance].longitude = [NSString stringWithFormat:@"%.6f", crnLoc.coordinate.longitude];
             [Singleton sharedInstance].latitude = [NSString stringWithFormat:@"%.6f", crnLoc.coordinate.latitude];
             
             //after Singleton has all address data, we will fire new method to collect weather-data
             if([Singleton sharedInstance].address)
                 [self performSelectorOnMainThread:@selector(printAddress) withObject:nil waitUntilDone:YES];
         } else
             NSLog(@"%@", error.debugDescription);
     }];
}

-(void)printAddress{
    NSLog(@"zip: %@, lat: %@, long: %@, address: %@", [Singleton sharedInstance].zipcode, [Singleton sharedInstance].latitude, [Singleton sharedInstance].longitude, [Singleton sharedInstance].address);
    
    CurrentWeather *weather = [CurrentWeather new];
    self.currentWeather = weather;
    [weather getWeather];
}

@end

