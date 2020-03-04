//
//  UserModel.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
//status

- (instancetype)init {
    self = [super init];
    if (self) {
        _avatar = @"";
        _userID = @"";
        _name = @"";
        _isEnabled = @"";
        _accessToken = @"";
        _phone = @"";
        _codeName = @"";
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _avatar =  [NSString stringWithFormat:@"%@",dictionary[@"avatar"]];
        _userID = [NSString stringWithFormat:@"%@",dictionary[@"userId"]] ;
        _name =  [NSString stringWithFormat:@"%@",dictionary[@"userName"]];
        _isEnabled = [NSString stringWithFormat:@"%@",dictionary[@"status"]] ;
        _accessToken =  [NSString stringWithFormat:@"%@",dictionary[@"accessToken"]];
        _phone =  [NSString stringWithFormat:@"%@",dictionary[@"mobile"]];
        _codeName =  [NSString stringWithFormat:@"%@",dictionary[@"codeName"]];
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
        _codeName = other.codeName;
        
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
     [aCoder encodeObject:self.codeName forKey:@"codeName"];
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
        self.codeName = [aDecoder decodeObjectForKey:@"codeName"];
    }
    return self;
}
@end
