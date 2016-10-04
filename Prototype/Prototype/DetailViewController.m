//
//  DetailVC.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/3/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    self.label.text = self.note;
}

@end
