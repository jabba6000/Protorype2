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
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndOne;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndTwo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndThree;

@property (strong, nonatomic) CoreDataManager *myManager;
@property (strong, nonatomic) IBOutlet UIButton *myButtonView;

@end

@implementation MainVC

- (IBAction)getForecastButton:(UIButton *)sender {
    
    //Yes, I know that warinig is shown here
    //I've been trying to use modern UIAlertController, but there was a popular iOS-9 bug
    //that's why I decided not to handle with this issue, but use old good UIAlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Weather For Tommorow"
                                                    message:[Singleton sharedInstance].weatherTomorrow
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)viewDidLoad{

    //while there is no forecast data, button to request forecast for tomorrow is not enable
    self.myButtonView.enabled=NO;
    
    //Here we handle with activity indicators (start them while no data came from Singleton object)
    [self.activityIndOne startAnimating];
    [self.activityIndTwo startAnimating];
    [self.activityIndThree startAnimating];
    self.activityIndOne.hidesWhenStopped=YES;
    self.activityIndTwo.hidesWhenStopped=YES;
    self.activityIndThree.hidesWhenStopped=YES;
    
    CoreDataManager *mngr = [CoreDataManager new];
    self.myManager = mngr;
    
    //Here we KV-observing Singleton's final value (timeOfRequest). When It recieves the value, the observer will fire,
    //because since that moment Singleton object will have all needed values to fill Labels
    [[Singleton sharedInstance] addObserver:self forKeyPath:@"timeOfRequest" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

//Method that will fire after Singleton carrier will collect all values (timeOfRequest - is the last one)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Now Singleton carrier has all values");
    
    //Stop activity Indicators, because we can fill Lavels with data now
    [self.activityIndOne stopAnimating];
    [self.activityIndTwo stopAnimating];
    [self.activityIndThree stopAnimating];
    
    //Now we can ask for weather forecast for tomorrow
    self.myButtonView.enabled=YES;
    
    //Let's add all data to labels
    self.coordinatesLabel.text = [NSString stringWithFormat:@"%@,\n%@", [Singleton sharedInstance].longitude, [Singleton sharedInstance].latitude];
    self.addressLabel.text = [NSString stringWithFormat:@"%@", [Singleton sharedInstance].address];
    self.weatherLabel.text = [NSString stringWithFormat:@"%@", [Singleton sharedInstance].weatherToday];
    
    //Now we have all data we need, so we reloading View
    [self reloadInputViews];
    
    //At the end we saving all data to CoreData Storage
    [self.myManager saveToCoreDataStorage];
}

@end
