//
//  FileManager.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/8/2.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface FileManager : NSObject

+(NSString *)getFileSizeWithPath:(NSString * )path ;

//从某个路径中移除文件
+ (BOOL)removeFileOfPath:(NSString *)filePath;

@end
