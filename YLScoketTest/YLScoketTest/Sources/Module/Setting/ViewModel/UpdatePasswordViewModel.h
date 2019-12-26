//
//  UpdatePasswordViewModel.h
//  YLScoketTest
//
//  Created by hoggen on 2019/12/26.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdatePasswordViewModel : NSObject

@property (nonatomic, retain)RACCommand *command;
@property (nonatomic, retain)NSDictionary *parame;

@end

NS_ASSUME_NONNULL_END
