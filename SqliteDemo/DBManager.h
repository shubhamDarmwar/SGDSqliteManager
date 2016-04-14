//
//  DBManager.h
//  SqliteDemo
//
//  Created by Laxman Murugappan on 4/14/16.
//  Copyright © 2016 EmpoweringVisions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBManager : NSObject

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL) saveDataRegisterNo:(NSString*)registerNumber name:(NSString*)name
      department:(NSString*)department year:(NSString*)year;
-(NSArray*) findByRegisterNumber:(NSString*)registerNumber;
@property (nonatomic,retain) NSString * databasePath;
@end
