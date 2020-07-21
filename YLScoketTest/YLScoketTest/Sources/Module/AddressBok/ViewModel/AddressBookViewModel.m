//
//  AddressBookViewModel.m
//  YLScoketTest
//
//  Created by hoggen on 2019/11/19.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "AddressBookViewModel.h"
#import "FiendshipModel.h"
#import "SearchUserModel.h"


@implementation AddressBookViewModel
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initSource];
    }
    return self;
}

- (void)initSource
{
    @weakify(self)
    _friendscommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString * input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [[NetworkManager sharedInstance] getWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Friendships_List]  param:nil needToken:true showToast:true returnBlock:^(NSDictionary *returnDict) {
                
                if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                    NSArray * users = returnDict[@"data"];
                    NSMutableArray<FiendshipModel *> * friends = [NSMutableArray array];
                    for (NSDictionary * temp in users) {
                        FiendshipModel * model = [FiendshipModel yy_modelWithDictionary: temp];
                        // NSLog(@"%@  ===   %@",model.user.name,model.user.userId);
                        [friends addObject: model];
                    }
                    [subscriber sendNext: friends];
                    [subscriber sendCompleted];
                    //NSLog(@"朋友列表： %@",users);
                }else {
                    [subscriber sendNext: nil];
                    [subscriber sendCompleted];
                }
                
            }];
            return  nil;
        }];
        
    }];
    
    _applyFriendscommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString * input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [[NetworkManager sharedInstance] getWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,ApplyFriendships_List]  param:nil needToken:true showToast:true returnBlock:^(NSDictionary *returnDict) {
                
                if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                    NSArray * users = returnDict[@"data"];
                    NSMutableArray<FiendshipModel *> * friends = [NSMutableArray array];
                    for (NSDictionary * temp in users) {
                        FiendshipModel * model = [FiendshipModel yy_modelWithDictionary: temp];
                        // NSLog(@"%@  ===   %@",model.user.name,model.user.userId);
                        [friends addObject: model];
                    }
                    [subscriber sendNext: friends];
                    [subscriber sendCompleted];
                    //NSLog(@"朋友列表： %@",users);
                }else {
                    [subscriber sendNext: nil];
                    [subscriber sendCompleted];
                }
                
            }];
            return  nil;
        }];
        
    }];
    
    _updateFriendshipcommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Update_Friendship_info] paramBody:input needToken:true showToast:true  returnBlock:^(NSDictionary *returnDict) {
                if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                    NSLog(@"%@",returnDict);
                    [subscriber sendNext: @(true)];
                    [subscriber sendCompleted];
                }else {
                    [subscriber sendNext: nil];
                    [subscriber sendCompleted];
                }
                
            }];
            return  nil;
        }];
        
    }];
    
    _addFriendshipcommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Agree_Friendship] paramBody:input needToken:true showToast:true returnBlock:^(NSDictionary *returnDict) {
                if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                    NSLog(@"%@",returnDict);
                    [subscriber sendNext: @(true)];
                    [subscriber sendCompleted];
                }else {
                    [subscriber sendNext: nil];
                    [subscriber sendCompleted];
                }
                
            }];
            return  nil;
        }];
        
    }];
    
    _searchFriendshipcommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Search_Friends] paramBody:input needToken:true showToast:true returnBlock:^(NSDictionary *returnDict) {
                if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                    NSLog(@"%@",returnDict);
                    NSArray * users = returnDict[@"data"];
                    NSMutableArray<SearchUserModel *> * friends = [NSMutableArray array];
                    for (NSDictionary * temp in users) {
                        SearchUserModel * model = [SearchUserModel yy_modelWithDictionary: temp];
                        // NSLog(@"%@  ===   %@",model.user.name,model.user.userId);
                        [friends addObject: model];
                    }
                    [subscriber sendNext: friends];
                    [subscriber sendCompleted];
                }else {
                    [subscriber sendNext: nil];
                    [subscriber sendCompleted];
                }
                
            }];
            return  nil;
        }];
        
    }];
    
}

-(void)getFriendscommand {
    [_friendscommand execute: nil];
}

-(void)getApplyFriendscommand {
    [_applyFriendscommand execute: nil];
}

-(void)updateFriendshipcommand:(NSMutableDictionary *)input {
    [_updateFriendshipcommand execute:input];
}
-(void)addFriendshipcommand:(NSMutableDictionary *)input{
    [_addFriendshipcommand execute:input];
}

-(void)searchFriendshipcommand:(NSMutableDictionary *)input{
    [_searchFriendshipcommand execute:input];
}

/**
 联系人数组排序
 
 @param array 原始联系人数组数据
 @return 排序后的联系人数组
 */
+ (NSMutableArray *) getContactListDataBy:(NSMutableArray *)array{
    
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//排序
        int i;
        NSString *strA = [((YLUserModel *)obj1).name transformCharacter];
        NSString *strB = [((YLUserModel *)obj2).name transformCharacter];
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (YLUserModel *contact in serializeArray) {
        char c = [[contact.name transformCharacter] characterAtIndex:0];
        if (!isalpha(c)) {
            [oth addObject:contact];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:contact];
        }
        else {
            [data addObject:contact];
        }
    }
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}


/**
 获取分区数(姓氏首字母)
 
 @param array 排序后的联系人数组
 @return [A,B,C,D.....]
 */
+ (NSMutableArray *)getContactListSectionBy:(NSMutableArray *)array {
    
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:UITableViewIndexSearch]; // 索引栏最上方的搜索icon
    for (NSArray *item in array) {
        YLUserModel *model = [item objectAtIndex:0];
        char c = [[model.name transformCharacter] characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}



@end
