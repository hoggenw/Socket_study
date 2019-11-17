//
//  RegisterViewModel.h
//  YLScoketTest
//
//  Created by hoggen on 2019/11/15.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewModel : UIView
@property (nonatomic, strong) RACCommand *registerCommand;
@property (nonatomic, copy) NSDictionary *registerInfo;

@end

NS_ASSUME_NONNULL_END
