//
//  FiendshipModel.h
//  YLScoketTest
//
//  Created by hoggen on 2019/12/18.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface FiendshipModel : NSObject

@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *friendId;
@property (nonatomic, copy) NSString *firendCategoryName;
@property (nonatomic, copy) NSString *userCategoryName;
@property (nonatomic, copy) NSString *friendRemark;
@property (nonatomic, copy) NSString *userRemark;
@property (nonatomic, copy) YLUserModel *user;
@property (nonatomic, copy) YLUserModel *friend;

@end

NS_ASSUME_NONNULL_END
