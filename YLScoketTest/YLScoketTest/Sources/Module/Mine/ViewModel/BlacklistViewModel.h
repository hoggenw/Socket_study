//
//  BlacklistViewModel.h
//  YLScoketTest
//
//  Created by hoggen on 2020/1/8.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlacklistViewModel : NSObject

@property (nonatomic, strong) RACCommand *blackListCommand;
@property (nonatomic, strong) RACCommand *deleteBlackshipCommand;

-(void)getBlackList;
-(void)deleteBlackship:(NSMutableDictionary *)input;

@end

NS_ASSUME_NONNULL_END
