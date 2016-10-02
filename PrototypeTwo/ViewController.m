//
//  ViewController.m
//  PrototypeTwo
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *zipcode;

@end

@implementation ViewController
{
    //Этот менеджер - ключевая фишка, чтобы отлавливать геоданные
    CLLocationManager *locationManager;
    //эти две переменные чтобы конвертировать данные в конкретный адрес
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    // в нашем случае сработает разово после нажатия
    // кнопки (в делегате останавливается сразу же)
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

//Это для того, чтобы отображать ошибки
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


//Это основной делегатный метод для CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    //получаем последнюю точку из массива посещенных точек
    CLLocation *crnLoc = [locations lastObject];
    
//    NSLog(@"didUpdateToLocation: %@", crnLoc);
    
    //для экономии батарейки, останавливаем постоянное обновление геоданных
    [locationManager stopUpdatingLocation];
    
    // Здесь осуществялется перекодировка геоданных в реальный адрес
    [geocoder reverseGeocodeLocation:crnLoc completionHandler:^(NSArray *placemarks, NSError *error)
     {

         if (error == nil && [placemarks count] > 0) {
             placemark = [placemarks lastObject];
             
             self.address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                             placemark.subThoroughfare,
                             placemark.thoroughfare,
                             placemark.postalCode,
                             placemark.locality,
                             placemark.administrativeArea,
                             placemark.country];
             self.zipcode = placemark.postalCode;
             
             if(self.address)
                [self performSelectorOnMainThread:@selector(printAddress) withObject:nil waitUntilDone:YES];
         } else {
             NSLog(@"%@", error.debugDescription);
         }
         
     }];
    
    if (crnLoc != nil) {
        self.longitude = [NSString stringWithFormat:@"%.10f", crnLoc.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%.10f", crnLoc.coordinate.latitude];
        NSLog(@"lat and long are ready");
    }
    
}

-(void)printAddress{
    NSLog(@"zip: %@, lat: %@, long: %@, address: %@", self.zipcode, self.latitude, self.longitude, self.address);
}


@end
