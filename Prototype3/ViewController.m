//
//  ViewController.m
//  Prototype3
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "ViewController.h"

#import "FKDataManager.h"
#import "FKForecast.h"
#import "FKLocation.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *forecasts;  //тут погода на 7 дней хранится
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *result1;
@property (strong, nonatomic) NSString *result2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.zipcode = @"90001";

    NSError *requestError = nil;
    BOOL requested = [[FKDataManager sharedManager] requestForecastsForZipcode:self.zipcode
                completion:^(NSArray *forecasts, NSError *error) {
                    if (forecasts)
                    {
                        [self processForecasts:forecasts error:error];
                        NSLog(@"%lu", (unsigned long)[forecasts count]);
                        
                        FKForecast *forecast = [self.forecasts objectAtIndex:0]; //0 - это сегодня
                        self.result1 = [NSString stringWithFormat:@"%@ — %@", [self.dateFormatter stringFromDate:forecast.startDate], [self.dateFormatter stringFromDate:forecast.endDate]];
                        self.result2 = [NSString stringWithFormat:@"Max %@°F | Min %@°F | Prec %@%%", forecast.maximumTemperature, forecast.minimumTemperature, forecast.probabilityOfPrecipitation];
                        
                        if(forecast)
                            NSLog(@"\n %@ \n %@", self.result1, self.result2);
                    }
                } error:&requestError];
    if (!requested)
    {
#if DEBUG
        NSLog(@"Error requesting forecasts: %@", requestError.localizedDescription);
#endif
    }
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return _dateFormatter;
}

- (void)processForecasts:(NSArray *)forecasts error:(NSError *)error
{
#if DEBUG
    if (!forecasts) {
        NSLog(@"Error encountered during request: %@", error.localizedDescription);
    }
#endif
    
    self.forecasts = forecasts;
}

@end
