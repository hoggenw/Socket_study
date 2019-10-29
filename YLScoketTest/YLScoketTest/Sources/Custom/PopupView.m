//
//  PopupView.m
//  Telegraph
//
//  Created by 王留根 on 2018/5/11.
//

#import "PopupView.h"
#import "DatePickerView.h"


@interface PopupView()<UITextFieldDelegate,DatePickerViewDelegate>


@property (nonatomic, strong)UIView *backView;
@property(nonatomic, strong)UIView * titleView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * timeHintLabel;
//
@property(nonatomic, strong)UITextField * timeBeginFeild;
@property (weak, nonatomic) UITextField * timeEndField;

//
@property(nonatomic, assign) NSInteger typeFeild;
//

@property(nonatomic, strong)UITextField * titleFeild;
@property(nonatomic, strong)UITextField * villageFeild;//initiator
@property(nonatomic, strong)UITextField * initiatorFeild;


@property(nonatomic, strong)UIButton * choiceExpressButton;
@property (nonatomic, strong) UIToolbar *toolBar;


@property (nonatomic, assign) NSInteger doneType;
@property (nonatomic, strong)UITapGestureRecognizer * tapGesture;

@property (nonatomic, assign)double beginTime;
@property (nonatomic, assign)double endTime;

@property (nonatomic, strong) UIToolbar *communityToolBar;


@end

@implementation PopupView

- (instancetype)initWithNoneView{
    
    self  = [super initWithFrame:CGRectMake(0 , kNavigationHeight , ScreenWidth, ScreenHeight)];
    
    if (self) {
        
        _beginTime = 0;
        _endTime = 0;
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewHidden)];
        [self addGestureRecognizer: _tapGesture] ;
        self.doneType = 1;
        [[[UIApplication sharedApplication].delegate window] addSubview:self];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        UIView * backView= [UIView new];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 4;
        backView.clipsToBounds = true;
        
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(0);
            make.height.equalTo(@(360));
        }];
        
        
        _titleView = [UIView new];
        _titleView.backgroundColor = [UIColor blackColor];
        [backView addSubview: _titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(0);
            make.left.right.equalTo(backView);
            make.height.equalTo(@(44));
        }];
        self.titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize: 15];
        _titleLabel.text = @"列表筛选";
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleView addSubview: _titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.titleView);
        }];
        
        
        self.timeHintLabel = [UILabel new];
        _timeHintLabel.font = [UIFont systemFontOfSize: 15];
        _timeHintLabel.text = @"开始投票时间";
        _timeHintLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [backView addSubview: _timeHintLabel];
        [_timeHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom).offset(10);
            make.left.equalTo(self.titleView.mas_left).offset(10);
        }];
        
        
        self.timeBeginFeild = [self createTextFeild];
        [backView addSubview:self.timeBeginFeild];
        self.timeBeginFeild.placeholder = @"开始时间";
        self.timeBeginFeild.delegate = self;
        [self.timeBeginFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeHintLabel.mas_bottom).offset(2);
            make.left.equalTo(backView.mas_left).offset(10);
            make.right.equalTo(backView.mas_centerX).offset(-4);
            make.height.equalTo(@(35));
        }];
        UIImageView * timeLog = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        timeLog.image = [UIImage imageNamed:@"vote_date_icon"];
        self.timeBeginFeild.rightView = timeLog;
        
        UILabel *lineLabel = [UILabel new];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [backView addSubview: lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeBeginFeild.mas_right).offset(2);
            make.centerY.equalTo(self.timeBeginFeild.mas_centerY);
            make.width.equalTo(@(6));
            make.height.equalTo(@(1));
        }];
        
        self.timeEndField = [self createTextFeild];
        [backView addSubview:self.timeEndField];
        self.timeEndField.placeholder = @"结束时间";
        self.timeEndField.delegate = self;
        [self.timeEndField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeHintLabel.mas_bottom).offset(2);
            make.left.equalTo(lineLabel.mas_right).offset(1);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.height.equalTo(@(35));
        }];
        UIImageView * timeLog1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        timeLog1.image = [UIImage imageNamed:@"vote_date_icon"];
        self.timeEndField.rightView = timeLog1;
        
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize: 15];
        titleLabel.text = @"标题";
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [backView addSubview: titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(10);
            make.top.equalTo(self.timeBeginFeild.mas_bottom).offset(10);
        }];
        
        
        self.titleFeild = [self createTextFeild];
        [backView addSubview:self.titleFeild];
        self.titleFeild.placeholder = @"请输入标题";
        self.titleFeild.delegate = self;
        [self.titleFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(2);
            make.left.equalTo(backView.mas_left).offset(10);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.height.equalTo(@(35));
        }];
        
        
        UILabel * villageLabel = [UILabel new];
        villageLabel.font = [UIFont systemFontOfSize: 15];
        villageLabel.text = @"小区名称";
        villageLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [backView addSubview: villageLabel];
        [villageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(10);
            make.top.equalTo(self.titleFeild.mas_bottom).offset(10);
        }];
        
        
        self.villageFeild = [self createTextFeild];
        [backView addSubview:self.villageFeild];
        self.villageFeild.placeholder = @"请输入小区名称";
        self.villageFeild.delegate = self;
        [self.villageFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(villageLabel.mas_bottom).offset(2);
            make.left.equalTo(backView.mas_left).offset(10);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.height.equalTo(@(35));
        }];
        
        
        UILabel * beiginManLabel = [UILabel new];
        beiginManLabel.font = [UIFont systemFontOfSize: 15];
        beiginManLabel.text = @"发起人";
        beiginManLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [backView addSubview: beiginManLabel];
        [beiginManLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(10);
            make.top.equalTo(self.villageFeild.mas_bottom).offset(10);
        }];
        
        
        self.initiatorFeild = [self createTextFeild];
        [backView addSubview:self.initiatorFeild];
        self.initiatorFeild.placeholder = @"请输入发起人";
        self.initiatorFeild.delegate = self;
        [self.initiatorFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(beiginManLabel.mas_bottom).offset(2);
            make.left.equalTo(backView.mas_left).offset(10);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.height.equalTo(@(35));
        }];
        
        UIButton *sureButton = [UIButton new];
        [sureButton setTitle:@"确  认" forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureButton.backgroundColor = ThemeColor;
        [sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(40));
            make.left.equalTo(backView.mas_left);
            make.right.equalTo(backView.mas_centerX);
            make.bottom.equalTo(backView.mas_bottom).offset(0);
        }];
        sureButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        sureButton.layer.borderWidth = 0.5;
        
        
        UIButton *cancelButton = [UIButton new];
        
        [cancelButton setTitle:@"重  置" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelButton setTitleColor: ThemeColor forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(resetButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:cancelButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(40));
            make.right.equalTo(backView.mas_right);
            make.left.equalTo(backView.mas_centerX);
            make.bottom.equalTo(backView.mas_bottom);
        }];
        cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cancelButton.layer.borderWidth = 0.5;
        
    }
    
    
    return self;
}

- (instancetype)initWithChicoeProject {
    self  = [super initWithFrame:CGRectMake(0 , kNavigationHeight , ScreenWidth, ScreenHeight)];
    
    if (self) {
        
        _beginTime = 0;
        _endTime = 0;
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewHidden)];
        [self addGestureRecognizer: _tapGesture] ;
        self.doneType = 1;
        [[[UIApplication sharedApplication].delegate window] addSubview:self];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        UIView * backView= [UIView new];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 4;
        backView.clipsToBounds = true;
        
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@(240));
        }];
        
        
        _titleView = [UIView new];
        _titleView.backgroundColor = [UIColor blackColor];
        [backView addSubview: _titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(0);
            make.left.right.equalTo(backView);
            make.height.equalTo(@(44));
        }];
        self.titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize: 15];
        _titleLabel.text = @"项目筛选";
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleView addSubview: _titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.titleView);
        }];
        
        
     
        
        
        UILabel * villageLabel = [UILabel new];
        villageLabel.font = [UIFont systemFontOfSize: 15];
        villageLabel.text = @"社区";
        villageLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [backView addSubview: villageLabel];
        [villageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(10);
            make.top.equalTo(self.titleView.mas_bottom).offset(10);
        }];
        
        
        self.villageFeild = [self createTextFeild];
        [backView addSubview:self.villageFeild];
        self.villageFeild.placeholder = @"请选择您筛选的社区";
        self.villageFeild.delegate = self;
        [self.villageFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(villageLabel.mas_bottom).offset(2);
            make.left.equalTo(backView.mas_left).offset(10);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.height.equalTo(@(35));
        }];

        
        
        UILabel * beiginManLabel = [UILabel new];
        beiginManLabel.font = [UIFont systemFontOfSize: 15];
        beiginManLabel.text = @"项目名称";
        beiginManLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [backView addSubview: beiginManLabel];
        [beiginManLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(10);
            make.top.equalTo(self.villageFeild.mas_bottom).offset(10);
        }];
        
        
        self.initiatorFeild = [self createTextFeild];
        [backView addSubview:self.initiatorFeild];
        self.initiatorFeild.placeholder = @"请输入项目名称";
        self.initiatorFeild.delegate = self;
        [self.initiatorFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(beiginManLabel.mas_bottom).offset(2);
            make.left.equalTo(backView.mas_left).offset(10);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.height.equalTo(@(35));
        }];
        
        UIButton *sureButton = [UIButton new];
        [sureButton setTitle:@"确  认" forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureButton.backgroundColor = ThemeColor;
        [sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(40));
            make.left.equalTo(backView.mas_left);
            make.right.equalTo(backView.mas_centerX);
            make.bottom.equalTo(backView.mas_bottom).offset(0);
        }];
        sureButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        sureButton.layer.borderWidth = 0.5;
        
        
        UIButton *cancelButton = [UIButton new];
        
        [cancelButton setTitle:@"重  置" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelButton setTitleColor: ThemeColor forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(resetButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:cancelButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(40));
            make.right.equalTo(backView.mas_right);
            make.left.equalTo(backView.mas_centerX);
            make.bottom.equalTo(backView.mas_bottom);
        }];
        cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cancelButton.layer.borderWidth = 0.5;
        
    }
    
    
    return self;
}


-(UITextField *)createTextFeild {
    UITextField *textField = [[UITextField alloc] init];
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([YLDeviceUtil isPhone5]) {
        textField.font = [UIFont systemFontOfSize:12];
    }else{
        textField.font = [UIFont systemFontOfSize:14];
    }
    
    textField.textColor = [UIColor blackColor];
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 2;
    textField.clipsToBounds = true;
    textField.returnKeyType = UIReturnKeyDone;
    textField.rightViewMode = UITextFieldViewModeAlways;
    return  textField;
}

#pragma mark -

- (void)sureButtonAction {
    
   
    
}


- (void)resetButtonAction {
    _timeBeginFeild.text = @"" ;
    _timeEndField.text = @"" ;
    _titleFeild.text = @"" ;
    _villageFeild.text = @"" ;//initiator
    _initiatorFeild.text = @"" ;
}




#pragma mark-
-(void) doneAction{
}

-(void)choiceExpressButtonAction {
    
    
}



-(void)removeResponder {
    [self endEditing: true];
}



- (void)selfViewHidden {
    [self removeFromSuperview];
    [self.backView removeFromSuperview];
    self.backView = nil;
    if ([self.delegate respondsToSelector: @selector(actionWithInfo:)]) {
        [self.delegate actionWithInfo:[NSNumber numberWithInteger:3]];
    }
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.timeBeginFeild) {
        self.typeFeild = 1;
        DatePickerView * pickView = [[DatePickerView alloc] initWithFrame: CGRectMake(0, ScreenHeight - 260,  ScreenWidth,  260)];
        [self addSubview: pickView];
        pickView.delegate = self;
        pickView.beginTime = _beginTime;
        pickView.endTime = _endTime;
        pickView.typeFeild = self.typeFeild;
        [pickView showDateTimePickerView];
         return  false;
    }
    if (textField == self.timeEndField) {
        self.typeFeild = 2;
        DatePickerView * pickView = [[DatePickerView alloc] initWithFrame: CGRectMake(0, ScreenHeight - 260,  ScreenWidth,  260)];
        [self addSubview: pickView];
        pickView.delegate = self;
        pickView.beginTime = _beginTime;
        pickView.endTime = _endTime;
        pickView.typeFeild = self.typeFeild;
        [pickView showDateTimePickerView];
         return  false;
    }
    
    if ((textField == self.villageFeild ||textField == self. initiatorFeild) && [YLDeviceUtil isPhone5]) {
        
    }
    
    [self removeGestureRecognizer: _tapGesture];
     return  true;
   
}
- (UIToolbar *)communityToolBar
{
    if (_communityToolBar == nil)
    {
        _communityToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _communityToolBar.barTintColor= ThemeColor;
        UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(communityToolBarButtonAction)];
        [item2 setTintColor:[UIColor whiteColor]];
        _communityToolBar.items = @[item1, item2];
    }
    return _communityToolBar;
}

-(void)communityToolBarButtonAction {

}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self addGestureRecognizer: _tapGesture];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan: touches withEvent: event];
    [self endEditing: true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}
-(void)didClickFinishDateTimePickerView:(NSString*)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm"];
    if (self.typeFeild == 1) {
        self.timeBeginFeild.text = date;
        NSDate *resDate = [formatter dateFromString: date];
        _beginTime  = [resDate timeIntervalSince1970];
        NSLog(@"%@",resDate);
    }else if(self.typeFeild == 2){
        self.timeEndField.text = date;
        NSDate *resDate = [formatter dateFromString: date];
        _endTime = [resDate timeIntervalSince1970];
    }
    NSLog(@"%@",date);
}

-(void)cancelDateTimePickerView{
    [self addGestureRecognizer: _tapGesture];
}

@end


