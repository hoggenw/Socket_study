//
//  PopupView.m
//  Telegraph
//
//  Created by 王留根 on 2018/5/11.
//

#import "PopupView.h"


@interface PopupView()


@property (nonatomic, strong)UIView *backView;


@end

@implementation PopupView

- (instancetype)initWithNoneView{
    
    self  = [super initWithFrame:CGRectMake(0 , kNavigationHeight , ScreenWidth, ScreenHeight)];
    
       if (self) {
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor clearColor];
        self.backView.frame = CGRectMake(0 , 0, ScreenWidth , ScreenHeight);
        [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewHidden)]];
        
        [[[UIApplication sharedApplication].delegate window] addSubview:self.backView];
        [[[UIApplication sharedApplication].delegate window] addSubview:self];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius = 2;
        self.clipsToBounds = NO;
        UIImageView * imageView= [UIImageView new];
        imageView.image = [UIImage imageNamed:@"icon_popup_shape"];//33*18;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_top);
            make.width.equalTo(@(17));
            make.height.equalTo(@(9));
        }];
        
        UIButton *serviceButton = [UIButton new];
        serviceButton.frame = CGRectMake(0, 0, 90, 40);
        
        [serviceButton setTitle:@"  客服" forState:UIControlStateNormal];
        serviceButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [serviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [serviceButton addTarget:self action:@selector(serviceCenter:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:serviceButton];
      
    }
    
    
    
    
    return self;
}




- (void)selfViewHidden {
    [self removeFromSuperview];
    [self.backView removeFromSuperview];
    self.backView = nil;
}



@end


