//
//  LocalSQliteManager.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "LocalSQliteManager.h"
#include "FMDB.h"

@implementation LocalSQliteManager{
    FMDatabase *fmdb;
}



-(instancetype)init {
    @throw [NSException exceptionWithName:@"单例类" reason:@"不能用此方法构造" userInfo:nil];
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        
    }
    return  self;
}
+(instancetype)sharedInstance {
    static LocalSQliteManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] initPrivate];
            
        }
    });
    return  manager;
}

//初始化数据库
-(void)creatDataBase{

    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[documentsPath firstObject] stringByAppendingPathComponent:@"experenceStore.db"];
    if (!fmdb) {
        fmdb=[[FMDatabase alloc]initWithPath:dbPath];
    }
    if ([fmdb open]) {
        //浏览记录
        [fmdb executeUpdate:@"create table if not exists BrowingTabel(itemId primary key not null,sellPrice not null,image not null, name not null,date not null);"];
        //订单信息
        [fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS newOrderTabel (stockId TEXT PRIMARY KEY NOT NULL,stockCount INTEGER,count INTEGER,itemId TEXT NOT NULL,sellPrice TEXT NOT NULL,originPrice TEXT NOT NULL,name TEXT NOT NULL,categoryId TEXT NOT NULL,dockId TEXT,dockName TEXT,phone not null,purchaseNum not null)"];

    }
}
@end
