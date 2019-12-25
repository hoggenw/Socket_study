//
//  SetViewModel.h
//  YLScoketTest
//
//  Created by hoggen on 2019/12/25.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetViewModel : NSObject
@property (nonatomic, retain)NSArray *setData;
@property (nonatomic, strong) RACCommand *quitLoginCommand;

- (void)quitLogin;

@end

NS_ASSUME_NONNULL_END
