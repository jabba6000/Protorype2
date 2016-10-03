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
    NSLog(@"Now %lu objects in History", [[self.myManager getDataFromCoreDataStorage] count]);
}

-(void)viewWillAppear{
    //эта обновляет значения тайтлов в таблице после их редактирования в DetailVC
    [self.myTableView reloadData];
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
    
    //Здесь мы обеспечиваем переход на второй экран по нажатию на ячейку
    
    /*
     Сначала мы берем и делаем VC из того, что есть в сториБорде.
     Затем определяем для него делегата - self, то есть CustomVC
     Затем по номеру выделенной ячейки берем объект из массива, который передадим в  DetailVC
     Наконец вызываем переход на DetailVC
     */
    
    self.myDetailVC = [self.storyboard
                       instantiateViewControllerWithIdentifier:@"Detail"];
    
    Storage *storage = [(NSMutableArray *)[self.myManager getDataFromCoreDataStorage] objectAtIndex:indexPath.row];
    
//    self.myDetailVC.delegate = self;
//
    self.myDetailVC.note = [NSString stringWithFormat:@"At the moment:\n %@\nAt this address:\n%@\nWith coordinates:\n%@,\n%@\n The weather was:\n %@", storage.time, storage.address, storage.latitude, storage.longitude, storage.weatherToday];

    self.myDetailVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:self.myDetailVC animated:YES];
}


@end
