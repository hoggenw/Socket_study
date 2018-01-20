//
//  UserModel.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _avatar = dictionary[@"avatar"];
        _couponCount = dictionary[@"couponCount"];
        _itemViewedCount = dictionary[@"itemViewedCount"];
        _verificationState = dictionary[@"isVerified"];
        _itemFollowedCount = dictionary[@"itemFollowedCount"];
        _email = dictionary[@"email"];
        _pendingPaymentCount = dictionary[@"pendingPaymentCount"];
        _pendingReceiptCount = dictionary[@"pendingReceiptCount"];
        _quickSupplyCount = dictionary[@"quickSupplyCount"];
        _name = dictionary[@"name"];
        _isEnabled = dictionary[@"isEnabled"];
        _accessToken = dictionary[@"accessToken"];
        _phone = dictionary[@"phone"];
        _contractStatus = dictionary[@"contractStatus"];
    }
    return self;
}

- (instancetype)initWithOther:(UserModel *)other accessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        _avatar = other.avatar;
        _couponCount = other.couponCount;
        _itemViewedCount = other.itemViewedCount;
        _verificationState = other.verificationState;
        _itemFollowedCount = other.itemFollowedCount;
        _email = other.email;
        _pendingPaymentCount = other.pendingPaymentCount;
        _pendingReceiptCount = other.pendingReceiptCount;
        _quickSupplyCount = other.quickSupplyCount;
        _name = other.name;
        _isEnabled = other.isEnabled;
        _accessToken = accessToken;
        _phone = other.phone;
        _contractStatus = other.contractStatus;
    }
    return self;
}


#pragma mark - Encode and Decode

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.couponCount forKey:@"couponCount"];
    [aCoder encodeObject:self.itemViewedCount forKey:@"itemViewedCount"];
    [aCoder encodeObject:self.verificationState forKey:@"isVerified"];
    [aCoder encodeObject:self.itemFollowedCount forKey:@"itemFollowedCount"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.pendingPaymentCount forKey:@"pendingPaymentCount"];
    [aCoder encodeObject:self.pendingReceiptCount forKey:@"pendingReceiptCount"];
    [aCoder encodeObject:self.quickSupplyCount forKey:@"quickSupplyCount"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.isEnabled forKey:@"isEnabled"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.contractStatus forKey:@"contractStatus"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.couponCount = [aDecoder decodeObjectForKey:@"couponCount"];
        self.itemViewedCount = [aDecoder decodeObjectForKey:@"itemViewedCount"];
        self.verificationState = [aDecoder decodeObjectForKey:@"isVerified"];
        self.itemFollowedCount = [aDecoder decodeObjectForKey:@"itemFollowedCount"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.pendingPaymentCount = [aDecoder decodeObjectForKey:@"pendingPaymentCount"];
        self.pendingReceiptCount = [aDecoder decodeObjectForKey:@"pendingReceiptCount"];
        self.quickSupplyCount = [aDecoder decodeObjectForKey:@"quickSupplyCount"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.isEnabled = [aDecoder decodeObjectForKey:@"isEnabled"] ;
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.contractStatus = [aDecoder decodeObjectForKey:@"contractStatus"];
    }
    return self;
}
@end
