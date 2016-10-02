//
//  CurrentWeather.h
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeather : NSObject

/*
 To use access to Internet via Simulator nedd to add 1 Dicionary to plist
 App Transport Security Settings
 and a key
 Allow Arbitrary Loads (BOOL)
 with value set to YES
 */

/*
 Add external library NOAAForecastKit
 to have an ability to get and parse weather data from 
 http://forecast.weather.gov/
 */

-(void)getWeather;

@end
