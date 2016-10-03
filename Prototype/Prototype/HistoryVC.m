//
//  HistoryVC.m
//  Prototype
//
//  Created by Uri Fuholichev on 10/2/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "HistoryVC.h"
#import "CoreDataManager.h"
#import "DetailVC.h"

@interface HistoryVC()

@property (strong, nonatomic)CoreDataManager *myManager;
@property(strong, nonatomic) DetailVC *myDetailVC;

@end

@implementation HistoryVC

-(void)viewDidLoad{
    
    CoreDataManager *mngr = [CoreDataManager new];
    self.myManager = mngr;
    NSLog(@"Now %lu objects in AppHistory", (unsigned long)[[self.myManager getDataFromCoreDataStorage] count]);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (NSInteger)[(NSArray *)[self.myManager getDataFromCoreDataStorage] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Storage *storage = [(NSMutableArray *)[self.myManager getDataFromCoreDataStorage] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    cell.textLabel.text = storage.time;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, (%@, %@)", storage.city, storage.latitude, storage.longitude];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
     When we touch a cell in tableView we will call DetailVC with all archieve data of some past request
     */
    
    self.myDetailVC = [self.storyboard
                       instantiateViewControllerWithIdentifier:@"Detail"];
    
    Storage *storage = [(NSMutableArray *)[self.myManager getDataFromCoreDataStorage] objectAtIndex:indexPath.row];
    
    //To pass the data between these two view  controllers, we use DetailVC's property "note"
    self.myDetailVC.note = [NSString stringWithFormat:@"At the moment:\n %@\nAt this address:\n%@\nWith coordinates:\n%@,\n%@\n The weather was:\n %@", storage.time, storage.address, storage.latitude, storage.longitude, storage.weatherToday];

    self.myDetailVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:self.myDetailVC animated:YES];
}


@end
