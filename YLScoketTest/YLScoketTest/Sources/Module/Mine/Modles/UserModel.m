//
//  UserModel.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


- (instancetype)init {
    self = [super init];
    if (self) {
        _avatar = @"";
        _userID = @"";
        _name = @"";
        _isEnabled = @"";
        _accessToken = @"";
        _phone = @"";
        _paySet = @"";
        _logintType= @"";
        _displayName = @"";
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _avatar = dictionary[@"avatar"];
        _userID = dictionary[@"userID"];
        _name = dictionary[@"name"];
        _isEnabled = dictionary[@"isEnabled"];
        _accessToken = dictionary[@"accessToken"];
        _phone = dictionary[@"phone"];
        _paySet = dictionary[@"paySet"];
        _logintType = dictionary[@"logintType"];
        _displayName = dictionary[@"displayName"];
    }
    return self;
}

- (instancetype)initWithOther:(UserModel *)other accessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        _avatar = other.avatar;
        _userID = other.userID;
        _name = other.name;
        _isEnabled = other.isEnabled;
        _accessToken = accessToken;
        _phone = other.phone;
        _paySet = other.paySet;
        _logintType = other.logintType;
        _displayName = other.displayName;
        
    }
    return self;
}


#pragma mark - Encode and Decode

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.isEnabled forKey:@"isEnabled"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.paySet forKey:@"paySet"];
    [aCoder encodeObject:self.logintType forKey:@"logintType"];
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.isEnabled = [aDecoder decodeObjectForKey:@"isEnabled"] ;
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.paySet = [aDecoder decodeObjectForKey:@"paySet"];
        self.logintType = [aDecoder decodeObjectForKey:@"logintType"];
        self.displayName = [aDecoder decodeObjectForKey:@"displayName"];
    }
    return self;
}
@end
