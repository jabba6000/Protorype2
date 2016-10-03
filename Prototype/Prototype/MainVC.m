//
//  MainVC.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "MainVC.h"
#import "Singleton.h"
#import "CoreDataManager.h"

@interface MainVC()

@property (strong, nonatomic) CoreDataManager *myManager;
@property(strong, nonatomic) NSString *weatherForTomorrowTmp; //it's for temporary data

@end

@implementation MainVC

- (IBAction)getForecastButton:(UIButton *)sender {
    
    NSLog(@"%@", [Singleton sharedInstance].weatherTomorrow);
}

-(void)viewDidLoad{

    CoreDataManager *mngr = [CoreDataManager new];
    self.myManager = mngr;
    
    //Here we observing Singleton last value. When It has this value, the observer will fire
    [[Singleton sharedInstance] addObserver:self forKeyPath:@"timeOfRequest" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}


-(void)viewWillAppear{
    
}

//Method that will fire after Singleton carrier will collect all values
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Now Singletone carrier now has all values");
    
    //Let's add all data to labels
    self.coordinatesLabel.text = [NSString stringWithFormat:@"%@,  %@", [Singleton sharedInstance].longitude, [Singleton sharedInstance].latitude];
    self.addressLabel.text = [NSString stringWithFormat:@"%@", [Singleton sharedInstance].address];
    self.weatherLabel.text = [NSString stringWithFormat:@"%@", [Singleton sharedInstance].weatherToday];
    
    //and add weather for tomorrow value, it won't be stored in Core Data Stirage
    self.weatherForTomorrowTmp = [Singleton sharedInstance].weatherTomorrow;
    
    [self reloadInputViews];
    
    [self.myManager saveToCoreDataStorage];
}

@end
