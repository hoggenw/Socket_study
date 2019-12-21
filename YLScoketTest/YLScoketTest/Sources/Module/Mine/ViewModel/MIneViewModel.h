//
//  MIneViewModel.h
//  YLScoketTest
//
//  Created by hoggen on 2019/11/20.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIneViewModel : NSObject
@property (nonatomic, strong) RACCommand *quitLoginCommand;
@property (nonatomic, copy) NSArray *dataSource;


@end

NS_ASSUME_NONNULL_END
