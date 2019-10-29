//
//  UserModel.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

/**头像*/
@property (nonatomic, copy) NSString *avatar;
/***/
@property (nonatomic, copy) NSString *userID;
/***/
@property (nonatomic, copy) NSString *name;
/**是否为正常用户*/
@property (nonatomic, copy)NSString *isEnabled;
/***/
@property (nonatomic, copy) NSString *accessToken;
/***/
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *logintType;

@property (nonatomic, copy) NSString *displayName;



//@(user.uid)  @(user.contactId),user.photoUrlSmall

//是否设置支付密码
@property (nonatomic, copy) NSString *paySet;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithOther:(UserModel *)other accessToken:(NSString *)accessToken;

@end
