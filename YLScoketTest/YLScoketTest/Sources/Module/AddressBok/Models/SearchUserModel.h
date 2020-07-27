//
//  SearchUserModel.h
//  YLScoketTest
//
//  Created by hoggen on 2020/7/20.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchUserModel : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *codeName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) BOOL isFriend;

@end

NS_ASSUME_NONNULL_END
