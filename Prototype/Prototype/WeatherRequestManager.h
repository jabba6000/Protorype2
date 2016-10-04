//
//  CurrentWeather.h
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherRequestManager : NSObject

/*
 To use access to Internet via Simulator we need to add 1 Dicionary to plist:
 App Transport Security Settings
 with a key:
 Allow Arbitrary Loads (BOOL)
 and with value set to: 
 YES
 */

/*
 Add external library NOAAForecastKit
 to have an ability to get and parse weather data from 
 http://forecast.weather.gov/
 */

/*
 External library, that was included in this project have at least 2 methods to recieve weather data:
 1)based on coordinates
 2)based on zipcode
 I decided to use the last one, at this moment Singleton object already has required zipcode
 */
- (void)getWeather;

@end
