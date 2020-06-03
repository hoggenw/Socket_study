//
//  UtilsHeader.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#ifndef UtilsHeader_h
#define UtilsHeader_h

#import "YLDeviceUtil.h"
#import "UserDefUtils.h"
#import "YLConst.h"
//#import "YLUMengHelper.h"
#import "FileManager.h"
#import "LanguageUtil.h"
#import "ChatDealUtils.h"

@protocol ActionSelcetControlDelegate <NSObject>

- (void) buttonAction: (NSInteger )index;

@end


@protocol NormalActionWithInfoDelegate <NSObject>

- (void)actionWithInfo:(id )obj;

@end

typedef NS_ENUM(NSInteger, CellType){
    Default = 0,
    
};

typedef NS_ENUM(NSInteger, PopupViewType){
    DefaultStyle  = 0,
  
};

typedef void(^SuccessCallBack)(NSDictionary * successDictionary);

#endif /* UtilsHeader_h */
