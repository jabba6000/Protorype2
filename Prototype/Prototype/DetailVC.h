//
//  DetailVC.h
//  Prototype
//
//  Created by Uri Fuholichev on 10/3/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVC : UIViewController

@property(strong, nonatomic) NSString *note;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
