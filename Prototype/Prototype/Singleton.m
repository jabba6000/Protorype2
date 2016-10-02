//
//  Singletone.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+(Singleton *)sharedInstance{
    static dispatch_once_t pred;
    static Singleton *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
