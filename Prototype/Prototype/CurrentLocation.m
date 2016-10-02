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
    //Этот менеджер - ключевая фишка, чтобы отлавливать геоданные
    CLLocationManager *locationManager;
    //эти две переменные чтобы конвертировать данные в конкретный адрес
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

-(void)getCurrentLocation{
    
    locationManager = [[CLLocationManager alloc] init];
    
    //эта переменная для перекодирования геоданных в реальный адрес
    geocoder = [[CLGeocoder alloc] init];
    
    //    ЗДЕСЬ НАЧИНАЕМ СОВМЕЩАТЬ
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //эти две строчки для того, чтобы симулятор показывал эмулируемые геоточки
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    // данная команда иницирует обновление геоданных
    // в нашем случае сработает разово после запуска приложения
    // (тк в делегате останавливается сразу же)
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

//Это для того, чтобы отображать ошибки
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //Здесь потом можно АлертВью
}

//Это основной делегатный метод для CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    //получаем последнюю точку из массива посещенных точек
    CLLocation *crnLoc = [locations lastObject];
    
    //для экономии батарейки, останавливаем постоянное обновление геоданных
    [locationManager stopUpdatingLocation];
        
    // Здесь осуществялется перекодировка геоданных в реальный адрес
    [geocoder reverseGeocodeLocation:crnLoc completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0) {
             placemark = [placemarks lastObject];
             
             [Singleton sharedInstance].address = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
                             placemark.country,
                             placemark.administrativeArea,
                             placemark.locality,
                             placemark.thoroughfare,
                             placemark.subThoroughfare];
             
             //страна, регион, город, улица, дом
             [Singleton sharedInstance].zipcode = placemark.postalCode;
             [Singleton sharedInstance].longitude = [NSString stringWithFormat:@"%.10f", crnLoc.coordinate.longitude];
             [Singleton sharedInstance].latitude = [NSString stringWithFormat:@"%.10f", crnLoc.coordinate.latitude];
             
             //как только мы получим все необходимые занчения, мы вызовем их сохрание или еще что-нить
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

