//
//  FriendInfoViewController.h
//  YLScoketTest
//
//  Created by hoggen on 2020/1/17.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiendshipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendInfoViewController : UIViewController

@property (nonatomic, strong)YLUserModel *userModel ;
@property (nonatomic, strong)FiendshipModel *friendsshipModel ;

@end

NS_ASSUME_NONNULL_END
