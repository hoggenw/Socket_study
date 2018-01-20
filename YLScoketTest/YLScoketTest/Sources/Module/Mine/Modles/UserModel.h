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
/**优惠券数量*/
@property (nonatomic, copy) NSString *couponCount;
/**浏览商品数量*/
@property (nonatomic, copy) NSString *itemViewedCount;
/** 商家资质认证状态  0未提交 1待审核 2审核通过 3认证失败  */
@property (nonatomic, copy) NSString *verificationState;
/**银行认证状态 0：未认证  10：审核处理中  20：已认证  -10： 审核不通过 */
@property (nonatomic, copy) NSString *contractStatus;
/**关注商品数量*/
@property (nonatomic, copy) NSString *itemFollowedCount;
/***/
@property (nonatomic, copy) NSString *email;
/**待付商品数量*/
@property (nonatomic, copy) NSString *pendingPaymentCount;
/**待收货商品数量*/
@property (nonatomic, copy) NSString *pendingReceiptCount;
/**快速补货商品数量*/
@property (nonatomic, copy) NSString *quickSupplyCount;
/***/
@property (nonatomic, copy) NSString *name;
/**是否为正常用户*/
@property (nonatomic, copy)NSString *isEnabled;
/***/
@property (nonatomic, copy) NSString *accessToken;
/***/
@property (nonatomic, copy) NSString *phone;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithOther:(UserModel *)other accessToken:(NSString *)accessToken;

@end
