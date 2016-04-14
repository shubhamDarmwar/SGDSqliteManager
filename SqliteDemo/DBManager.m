//
//  DBManager.m
//  SqliteDemo
//
//  Created by Laxman Murugappan on 4/14/16.
//  Copyright © 2016 EmpoweringVisions. All rights reserved.
//

#import "DBManager.h"
static DBManager * sharedInstance = nil;
static sqlite3 * database = nil;
static sqlite3_stmt * statement = nil;
@implementation DBManager

+(DBManager *)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSArray * dirPaths;
    NSString * docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    self.databasePath = [[NSString alloc ] initWithString:[docsDir stringByAppendingString:@"student.db"]];
    
    BOOL isSucess = YES;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.databasePath] == NO) {
        if (sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK) {
            char * errMsg;
            const char * sql_statement = "create table if not exists studentdetails (regno integer primary key,name text,department text,year text)";
            
            
            if (sqlite3_exec(database, sql_statement, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSucess = NO;
                NSLog(@"Can't create table");
            }
            sqlite3_close(database);
            return isSucess;
        }else{
            isSucess = NO;
            NSLog(@"fail to open/create database");
        }
    
    }
    NSLog(@"Dtabasepath  %@",self.databasePath);
    return isSucess;
}

-(BOOL)saveDataRegisterNo:(NSString *)registerNumber name:(NSString *)name department:(NSString *)department year:(NSString *)year{
    if (sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK) {
        NSString * insertSQL = [NSString stringWithFormat: @"insert into studentdetails (regno,name,department,year) values (\"%d\",\"%@\", \"%@\", \"%@\")",[registerNumber intValue],name,department,year];
        const char * insertQuery = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insertQuery, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            return YES;
            
        }else{
            sqlite3_reset(statement);
            return NO;
        }
        
    }
    sqlite3_reset(statement);
    return NO;
}

-(NSArray *)findByRegisterNumber:(NSString *)registerNumber{
    
    if (sqlite3_open([self.databasePath UTF8String], &database)==SQLITE_OK) {
        NSString * findSQL = [NSString stringWithFormat:@"select name,department,year from studentdetails where regno > \"%@\"",registerNumber];
        const char * findQuery = [findSQL UTF8String];
        NSMutableArray * resultArray = [[NSMutableArray alloc]init];
        if(sqlite3_prepare_v2(database, findQuery, -1, &statement, NULL)==SQLITE_OK){
//@@@@@@@@@@@@@@@@@@ FOR ONE PERTICULAR RECORD @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                        if (sqlite3_step(statement)==SQLITE_ROW) {
                            NSString * name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                            [resultArray addObject:name];
                            NSString * department = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                            [resultArray addObject:department];
                            NSString * year =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                            [resultArray addObject:year];
                            sqlite3_reset(statement);
                            return resultArray;
                        }else{
                            NSLog(@"Not found");
                            sqlite3_reset(statement);
                            return nil;
                        }
//@@@@@@@@@@@@@@@@@@@ FOR NUMBER OF RECORD @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//            while(sqlite3_step(statement)==SQLITE_ROW) {
//                NSString * name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
//                [resultArray addObject:name];
//                NSString * department = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
//                [resultArray addObject:department];
//                NSString * year =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
//                [resultArray addObject:year];
//            }
//            sqlite3_reset(statement);
//            if (resultArray.count != 0) {
//                return resultArray;
//            }else{
//                return nil;
//            }
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
            
            
        }
    }
    return nil;
}

@end
