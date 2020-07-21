//
//  FriendInfoViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2020/1/17.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "AddressBookViewModel.h"
#import "LoginViewModel.h"
#import "ChatListUserModel.h"
#import "ChatViewController.h"
#import "ChatUserModel.h"

@interface FriendInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *informationView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UITextField *categoryNameTextFeild ;
@property (nonatomic, strong) UITextField *remarkTextFeild ;
@property (nonatomic, strong) UIButton *remarkButton ;
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) AddressBookViewModel *viewModel;
@property (nonatomic, strong) LoginViewModel *personInfoModel;
@property (nonatomic, strong) UserModel * model;

@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initDataSource];
//    NSLog(@"%@",self.userModel.userId);
//    NSLog(@"%@",self.friendsshipModel.friend.userId);
//    NSLog(@"%@",self.friendsshipModel.user.userId);
    // Do any additional setup after loading the view.
}
- (void)initDataSource {
    _viewModel = [AddressBookViewModel new];
    _personInfoModel = [LoginViewModel new];
    
    @weakify(self)
    [_viewModel.updateFriendshipcommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        if (x != nil)
        {
            ChatListUserModel *item1  = [ChatListUserModel new];
            item1.userId = self.model.userID;
            item1.name = self.remarkTextFeild.text;
            item1.selfId = [[AccountManager sharedInstance] fetch].userID;
            if ([[LocalSQliteManager sharedInstance] isChatListUserModelExist: item1]) {
                [[LocalSQliteManager sharedInstance]insertChatListUserModel: item1];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Reload_Friend_Group object:nil];
            [YLHintView removeLoadAnimation];
        }
        
        
    }];
    
    [_personInfoModel.userInfoCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        if (x != nil)
        {
            self.model = x;
            [self refreshUI];
        }
        
        
    }];
    if (self.userModel != NULL && self.friendsshipModel != NULL) {
        NSDictionary * param = @{@"userId":self.userModel.userId, @"applyId":self.friendsshipModel.idStr};
        self.personInfoModel.userInfo = param;
    }
    
    
    
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
        make.addToSuperView(self.informationView).font(FONT(15)).textColor([UIColor colorWithHexString:@"0x666666"]).placeholder(@"七聊号");
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
        make.addToSuperView(remarkView).font(FONT(16)).textColor([UIColor colorWithHexString:@"0x333333"]);
    }];
    
    [self.remarkTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-120);
        make.top.equalTo(remarkView.mas_top).offset(5);
        make.bottom.equalTo(remarkView.mas_bottom).offset(-5);
    }];
    self.remarkTextFeild.delegate = self;
    
    self.remarkButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"更新备注",UIControlStateNormal).titleColorForState(UICOLOR(0x8EDEE9),UIControlStateNormal).addAction(self, @selector(remarkBtnClicked:), UIControlEventTouchUpInside).addToSuperView(self.view).titleFont(FONT(14));
    }];
    
    
    [self.remarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(remarkView.mas_top).offset(0);
        make.bottom.equalTo(remarkView.mas_bottom).offset(0);
    }];
    [self.remarkButton addLineWithSide:LineViewSideOutLeft lineColor:UIColor.lightGrayColor lineHeight:0.5 leftMargin:5 rightMargin:5];
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
    
    
    [self refreshUI];
    
}

- (void)refreshUI {
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:self.friendsshipModel.user.avatar] placeholderImage:IMAGE(@"self_header")];
    if (self.model) {
        self.name.text = self.model.name;
        self.categoryNameTextFeild.text = self.model.codeName;
    }
    
    self.remarkButton.hidden = true;
    self.applyButton.enabled = true;
    [self.applyButton setTitle:@"发起聊天" forState:UIControlStateNormal];
    if(self.friendsshipModel){
        if ([self.friendsshipModel.friend.userId isEqualToString: [[AccountManager sharedInstance] fetch].userID]) {
            
            self.remarkTextFeild.text = self.friendsshipModel.userCategoryName.length > 0 ?  self.friendsshipModel.userCategoryName : [NSString stringWithFormat:@"添加备注名"];
            
        }else{
            self.remarkTextFeild.text = self.friendsshipModel.firendCategoryName.length > 0 ?  self.friendsshipModel.firendCategoryName : [NSString stringWithFormat:@"添加备注名"];
        }
        
    }
}

-(void)confirmAction:(UIButton *)sender {
    //添加聊天
    ChatListUserModel *item1  = [ChatListUserModel new];
    item1.userId = self.model.userID;
    item1.name = self.model.name;
    item1.avatar = self.model.avatar;
    item1.date = [NSDate date];
    item1.messageCount = 0;
    item1.selfId = [[AccountManager sharedInstance] fetch].userID;
    if(self.friendsshipModel){
        if ([self.friendsshipModel.friend.userId isEqualToString: [[AccountManager sharedInstance] fetch].userID]) {
            
            item1.name = self.friendsshipModel.userCategoryName.length > 0 ?  self.friendsshipModel.userCategoryName : self.model.name;
            
        }else{
            item1.name  = self.friendsshipModel.firendCategoryName.length > 0 ?  self.friendsshipModel.firendCategoryName : self.model.name;
        }
        
    }
    
    
    if ([[LocalSQliteManager sharedInstance] isChatListUserModelExist: item1]) {
        ChatListUserModel *item2  = [ChatListUserModel new];
        item2.userId = self.model.userID;
        item2.name =  item1.name;
        item2.date = [NSDate date];
        item2.messageCount = 0;
        [[LocalSQliteManager sharedInstance] insertChatListUserModel:item2];
    }else{
        [[LocalSQliteManager sharedInstance] insertChatListUserModel:item1];
    }
    ChatViewController *chatVC  = [ChatViewController new];
    /**
     下面的这个 TLUser 就是具体到用户的一个数据 model
     */
    ChatUserModel *user7 = [[ChatUserModel alloc] init];
    user7.username = item1.name;
    user7.userID = item1.userId;
    user7.avatarURL = item1.avatar;
    chatVC.user = user7;
    
    // 隐藏底部的buttomBar 当 push 的时候
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}

-(void)remarkBtnClicked:(UIButton *)sender {
    [self.remarkTextFeild resignFirstResponder];
    NSLog(@"更新备注");
    if (self.remarkTextFeild.text.length > 0 ) {
        if (self.remarkTextFeild.text.length > 20) {
            [YLHintView showMessageOnThisPage:@"备注名长度不能大于20"];
            return;
        }
        NSMutableDictionary * input = [NSMutableDictionary dictionary];
        input[@"id"] = self.friendsshipModel.idStr;
        input[@"name"] = self.remarkTextFeild.text;
        [self.viewModel updateFriendshipcommand: input];
        
    }else{
        [YLHintView showMessageOnThisPage:@"请输入你想修改的备注名"];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.remarkButton.hidden = false;
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self remarkBtnClicked:nil];
    return true;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.remarkButton.hidden = true;
}

@end
