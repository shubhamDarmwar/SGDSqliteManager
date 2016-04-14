//
//  ViewController.m
//  SqliteDemo
//
//  Created by Laxman Murugappan on 4/13/16.
//  Copyright © 2016 EmpoweringVisions. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()
@property(nonatomic,retain)NSString * databasePath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    DBManager * dbm = [DBManager getSharedInstance];
    BOOL isSaved = [dbm saveDataRegisterNo:@"0" name:@"shbham0" department:@"etc" year:@"2015"];
    isSaved = [dbm saveDataRegisterNo:@"1" name:@"shbham1" department:@"etc" year:@"2015"];
    isSaved = [dbm saveDataRegisterNo:@"2" name:@"shbham2" department:@"etc" year:@"2015"];
    isSaved = [dbm saveDataRegisterNo:@"3" name:@"shbham3" department:@"etc" year:@"2015"];
    isSaved = [dbm saveDataRegisterNo:@"4" name:@"shbham4" department:@"etc" year:@"2015"];
    NSArray * recordArray =[dbm findByRegisterNumber:@"2"];
    NSLog(@"Record array  %@",recordArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
