//
//  SqViewController.m
//  SqliteDemo
//
//  Created by Laxman Murugappan on 5/18/16.
//  Copyright © 2016 EmpoweringVisions. All rights reserved.
//

#import "SqViewController.h"
#import <sqlite3.h>

@interface SqViewController ()
{
    NSString * dbPath;
    sqlite3 * DB,*DB2, *DB3 ;
}
@end

@implementation SqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL tag = [self createDB];
    BOOL inTag = [self insertData];
    BOOL ftag=[self fetch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)createDB{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * dirPath = [dirPaths lastObject];
    dbPath = [NSString stringWithFormat:@"%@/my.db",dirPath];
    
    NSLog(@"path == %@",dbPath);
    NSFileManager * fm =[NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:dbPath] == NO) {
        
        if (sqlite3_open([dbPath UTF8String], &DB) == SQLITE_OK) {
           
            char *error ;
            const char  * queryStr = "create table if not exists myTable(rNo integer primary key)";
            
            
                    if (sqlite3_exec(DB, queryStr, nil, nil, &error) != SQLITE_OK ) {
                        NSLog(@"cant create table");
                        return NO;
                    }
            
            return YES;
        }
        
        sqlite3_close(DB);
        
    }
    
    return NO;
}


-(BOOL)insertData{
    
    
    if (sqlite3_open([dbPath UTF8String], &DB) == SQLITE_OK) {
        int rno = 3;
        NSString * inSql = [NSString stringWithFormat: @"insert into myTable (rNo) values (%d)",rno];

        sqlite3_stmt * stmnt;
        sqlite3_prepare_v2(DB,[inSql UTF8String],-1, &stmnt,  nil);
        if (sqlite3_step(stmnt) == SQLITE_DONE) {
            sqlite3_close(DB);
            return YES;
        }
    }
    sqlite3_close(DB);
    return NO;
}

-(BOOL)fetch{

    if (sqlite3_open([dbPath UTF8String], &DB) == SQLITE_OK) {
        
        NSString * fetchQ = [NSString stringWithFormat:@"select * from myTable"];
        sqlite3_stmt * stmnt;
        if (sqlite3_prepare_v2(DB, [fetchQ UTF8String], -1, &stmnt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(stmnt) == SQLITE_ROW) {
                NSLog(@" r no = %s",sqlite3_column_text(stmnt,0));
            }
            
        }
        
    }
    
    

    
    
    
    sqlite3_close(DB);
    return NO;
}

@end
