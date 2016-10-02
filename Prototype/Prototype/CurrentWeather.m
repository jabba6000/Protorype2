//
//  CurrentWeather.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "CurrentWeather.h"

#import "FKDataManager.h"
#import "FKForecast.h"
#import "FKLocation.h"

#import "Singleton.h"

@interface CurrentWeather()

@property (strong, nonatomic) NSArray *forecasts;  //storing weather for 7 days
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *zipcode;   

@end

@implementation CurrentWeather

-(void)getWeather{

    self.zipcode = [Singleton sharedInstance].zipcode;
    
    NSError *requestError = nil;
    BOOL requested = [[FKDataManager sharedManager] requestForecastsForZipcode:self.zipcode
                                                                    completion:^(NSArray *forecasts, NSError *error)
    {
        if (forecasts)
        {
            [self processForecasts:forecasts error:error];
            
            FKForecast *forecast = [self.forecasts objectAtIndex:0]; //zero index - Today's weather
            
            
            
            
            [Singleton sharedInstance].weatherToday = [NSString stringWithFormat:@"Max %@°С | Min %@°С | Prec %@%%", [self convertToCelcius: forecast.maximumTemperature], [self convertToCelcius: forecast.minimumTemperature], forecast.probabilityOfPrecipitation];
            
            forecast = [self.forecasts objectAtIndex:1]; //zero index - Tomorrow's weather
            
            [Singleton sharedInstance].weatherTomorrow = [NSString stringWithFormat:@"Max %@°С | Min %@°С | Prec %@%%", [self convertToCelcius: forecast.maximumTemperature], [self convertToCelcius: forecast.minimumTemperature], forecast.probabilityOfPrecipitation];
            
            if(forecast)
                NSLog(@"%@, %@", [Singleton sharedInstance].weatherToday, [Singleton sharedInstance].weatherTomorrow);
            
            [self getCurrentTime];
        }
    }
    error:&requestError];
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

//No need to explain the meaning of this method
-(NSNumber*)convertToCelcius: (NSNumber *)num
{
    double unconvertedValue = [num intValue];
    NSNumber *number = [NSNumber numberWithInt:(unconvertedValue - 32)/1.8];
    return number;
}

//And we've added the request of current time to this class' methods
-(void)getCurrentTime{
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    [Singleton sharedInstance].timeOfRequest = dateString;
    NSLog(@"%@", [Singleton sharedInstance].timeOfRequest);
}
@end
