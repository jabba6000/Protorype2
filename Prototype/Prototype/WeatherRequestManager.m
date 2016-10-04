//
//  CurrentWeather.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "WeatherRequestManager.h"
#import "DataCollector.h"
// Importing of key headers of external library to parse data from XML
#import "FKDataManager.h"
#import "FKForecast.h"
#import "FKLocation.h"

@interface WeatherRequestManager()

@property (strong, nonatomic) NSArray *forecasts;  //This array will store weather for 7 days
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *zipcode;   

@end

@implementation WeatherRequestManager

- (void)getWeather {
    self.zipcode = [DataCollector sharedInstance].zipcode;
    NSError *requestError = nil;
    BOOL requested = [[FKDataManager sharedManager] requestForecastsForZipcode:self.zipcode
                                                                    completion:^(NSArray *forecasts, NSError *error) {
        if (forecasts) {
            [self processForecasts:forecasts error:error];
            FKForecast *forecast = [self.forecasts objectAtIndex:0]; // zero index - Today's weather
            // Here we collect currnet weather data
            [DataCollector sharedInstance].weatherToday = [NSString stringWithFormat:@"Max %@°С | Min %@°С | Prec %@%%", [self convertToCelcius: forecast.maximumTemperature], [self convertToCelcius: forecast.minimumTemperature], forecast.probabilityOfPrecipitation];
            forecast = [self.forecasts objectAtIndex:1]; //zero index - Tomorrow's weather
            // Here we collect tomorrow's weather data
            [DataCollector sharedInstance].weatherTomorrow = [NSString stringWithFormat:@"Max %@°С | Min %@°С | Prec %@%%", [self convertToCelcius: forecast.maximumTemperature], [self convertToCelcius: forecast.minimumTemperature], forecast.probabilityOfPrecipitation];
            if(forecast)
                NSLog(@"%@, %@", [DataCollector sharedInstance].weatherToday, [DataCollector sharedInstance].weatherTomorrow);
            [self getCurrentTime];
            // After the performing of this method Singletone will have all values we need
        }
    }
    error:&requestError];
    if (!requested) {
#if DEBUG
        NSLog(@"Error requesting forecasts: %@", requestError.localizedDescription);
#endif
    }
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return _dateFormatter;
}

- (void)processForecasts:(NSArray *)forecasts error:(NSError *)error {
#if DEBUG
    if (!forecasts) {
        NSLog(@"Error encountered during request: %@", error.localizedDescription);
    }
#endif
    self.forecasts = forecasts;
}

// The temperature values are returned in Fahrenheit degrees
// that's why I decided to convert them to Celcius
- (NSNumber*)convertToCelcius: (NSNumber *)num {
    double unconvertedValue = [num intValue];
    NSNumber *number = [NSNumber numberWithInt:(unconvertedValue - 32)/1.8];
    return number;
}

// And we've added the request of current time to the methods of Current Weather class
// just not to create another class for such a small work
- (void)getCurrentTime {
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    dateString = [formatter stringFromDate:[NSDate date]];
    // It will be the last piece of data collected by Singleton object
    [DataCollector sharedInstance].timeOfRequest = dateString;
    NSLog(@"%@", [DataCollector sharedInstance].timeOfRequest);
}

@end
