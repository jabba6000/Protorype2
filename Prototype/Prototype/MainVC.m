//
//  MainVC.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "MainVC.h"
#import "Singleton.h"
#import "CurrentLocation.h"

@interface MainVC()

@property(strong, nonatomic)CurrentLocation *curLct;

@end

@implementation MainVC

- (IBAction)getForecastButton:(UIButton *)sender {
}

-(void)viewDidLoad{

    if([Singleton sharedInstance].timeOfRequest==nil)
        NSLog(@"YAHOOO!");
    //
//    [self performSelectorOnMainThread:@selector(performRequest) withObject:nil waitUntilDone:YES];
}

//-(void)performRequest{
//    CurrentLocation *location = [CurrentLocation new];
//    self.curLct = location;
//    [location getCurrentLocation];
//}

-(void)viewWillAppear{
    
    if([Singleton sharedInstance].timeOfRequest==nil)
        NSLog(@"YAHOOO!");
    
}

@end
