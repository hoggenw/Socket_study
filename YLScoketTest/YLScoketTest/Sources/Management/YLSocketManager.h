//
//  YLSocketManager.h
//  YLScoketTest
//
//  Created by 王留根 on 17/2/14.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLSocketManager : NSObject

+(instancetype) share;

-(void)connectFirst;

-(void)disconnectFirst;

-(void)sendMassege:(NSString *) message;

@end
