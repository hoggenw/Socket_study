//
//  SearchDetailViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2020/7/21.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "AddressBookViewModel.h"

@interface SearchDetailViewController ()

@property (nonatomic, strong) UIImageView *informationView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UITextField *categoryNameTextFeild ;
@property (nonatomic, strong) UITextField *remarkTextFeild ;
@property (nonatomic, strong) UIButton *remarkButton ;
@property (nonatomic, strong) UIButton *nameButton ;
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) AddressBookViewModel *viewModel;


@end

@implementation SearchDetailViewController


- (void)viewDidLoad {
    self.title = @"操作";
    [super viewDidLoad];
    [self initUI];
    [self initDataSource];
    
}

- (void)initDataSource {
    _viewModel = [AddressBookViewModel new];
    @weakify(self)
    [_viewModel.createFriendshipcommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        if (x != nil)
        {
            
            [YLHintView showMessageOnThisPage:@"申请成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Reload_FriendShips object:nil];
            [YLHintView removeLoadAnimation];
            self.applyButton.enabled = false;
            [self.applyButton setTitle:@"已申请" forState:UIControlStateNormal];
        }
        
        
    }];
    
    
    
}
- (void)initUI {
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f4f5];
    _headerView.layer.cornerRadius = 26.f;
    _headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerView.layer.borderWidth = 2;
    _headerView.clipsToBounds = true;
    
    
    _informationView = [UIImageView new];
    _informationView.image = [UIImage imageWithColor:UIColor.whiteColor];
    _informationView.userInteractionEnabled = YES;
    [self.view addSubview:_informationView];
    [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.height.mas_equalTo(100);
    }];
    [_informationView addLineWithSide:LineViewSideInBottom lineColor:UIColor.lightGrayColor lineHeight:0.5 leftMargin:20 rightMargin:0];
    
    _headerView = [UIImageView new];
    _headerView.clipsToBounds = YES;
    
    [_informationView addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(52);
        make.left.equalTo(self.informationView).mas_offset(20).priorityHigh();
        make.centerY.equalTo(self.informationView.mas_centerY);
    }];
    
    _name = [UILabel makeLabel:^(LabelMaker *make) {
        make.font(BOLD_FONT(18)).textColor([UIColor colorWithHex:0x333333]).addToSuperView(self.informationView);
    }];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).mas_offset(16);
        make.top.equalTo(self.headerView.mas_top).offset(3);
    }];
    
    self.categoryNameTextFeild = [UITextField makeTextField:^(TextFieldMaker *make) {
        make.addToSuperView(self.informationView).font(FONT(15)).textColor([UIColor colorWithHexString:@"0x666666"]).placeholder(@"设置备注名");
    }];
    
    [self.categoryNameTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).mas_offset(16);
        make.right.equalTo(self.view.mas_right).offset(-80);
        make.bottom.equalTo(self.headerView.mas_bottom).offset(-3);
    }];
    
    
    UIView * remarkView = [UIView new];
    remarkView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview: remarkView];
    [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.informationView.mas_bottom);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    self.remarkTextFeild = [UITextField makeTextField:^(TextFieldMaker *make) {
        make.addToSuperView(remarkView).font(FONT(16)).textColor([UIColor colorWithHexString:@"0x333333"]).placeholder(@"设置好友备注信息");
    }];
    
    [self.remarkTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-120);
        make.top.equalTo(remarkView.mas_top).offset(5);
        make.bottom.equalTo(remarkView.mas_bottom).offset(-5);
    }];
    [remarkView addLineWithSide:LineViewSideInBottom lineColor:UIColor.lightGrayColor lineHeight:0.5 leftMargin:0 rightMargin:0];
    
    UIView * applyView = [UIView new];
    applyView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview: applyView];
    [applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkView.mas_bottom).offset(10);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    [applyView addLineWithSide:LineViewSideInBottom lineColor:UIColor.lightGrayColor lineHeight:0.5 leftMargin:0 rightMargin:0];
    [applyView addLineWithSide:LineViewSideInTop lineColor:UIColor.lightGrayColor lineHeight:0.5 leftMargin:0 rightMargin:0];
    
    self.applyButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        //        make.backgroundImageForState([UIImage imageWithColor:UIColor.blueColor], UIControlStateNormal).backgroundImageForState([UIImage imageWithColor:UIColor.blueColor], UIControlStateHighlighted).backgroundImageForState([UIImage imageWithColor:UICOLOR(0x8EDEE9)], UIControlStateDisabled);
        make.titleColorForState(UICOLOR(0x8EDEE9), UIControlStateNormal).titleColorForState(UIColor.grayColor, UIControlStateDisabled).titleFont(BOLD_FONT(16)).addAction(self, @selector(confirmAction:), UIControlEventTouchUpInside).addToSuperView(applyView);
    }];
    
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(applyView.mas_centerX);
        make.centerY.equalTo(applyView.mas_centerY);
        make.height.equalTo(@(40));
        make.width.equalTo(@(200));
    }];
    
    if(self.model){
        [_headerView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:IMAGE(@"self_header")];
        _name.text = self.model.codeName;
        self.applyButton.enabled = true;
        [self.applyButton setTitle:@"申请好友" forState:UIControlStateNormal];
        self.remarkTextFeild.enabled = true;
        
    }
    
    
}
-(void)confirmAction:(UIButton *)sender {
    NSLog(@"申请好友");
    if (self.categoryNameTextFeild.text.length > 10) {
        [YLHintView showMessageOnThisPage:@"备注名长度不能大于10"];
        return;
    }
    NSMutableDictionary * input = [NSMutableDictionary dictionary];
        input[@"firendCategoryName"] = self.categoryNameTextFeild.text;
      input[@"friendRemark"] = self.remarkTextFeild.text;
        input[@"userId"] = [AccountManager sharedInstance].fetch.userID;
        input[@"friendId"] = self.model.userId;
        [self.viewModel createFriendshipcommand: input];
    
}

@end
