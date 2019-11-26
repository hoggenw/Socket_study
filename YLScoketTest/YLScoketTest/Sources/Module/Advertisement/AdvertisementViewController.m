//
//  AdvertisementViewController.m
//  ftxmall
//
//  Created by 王留根 on 2017/7/4.
//  Copyright © 2017年 wanthings. All rights reserved.
//

#import "AdvertisementViewController.h"
#import "BannerScrollView.h"
#import "YLUITabBarViewController.h"
#import "YLNavigationController.h"
#import "LoginViewController.h"


@interface AdvertisementViewController()

@property(nonatomic,strong) BannerScrollView*  bannerScroller;
@property(nonatomic,strong) NSMutableArray<NSString *> * imageUrl;

@end

@implementation AdvertisementViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageUrl = [NSMutableArray array];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self GetAdvertising];
        });
        //_imageView = [UIImageView new];
    }
    return self;
}

- (void)setImageUrls:(NSMutableArray<NSString *> *)imageUrls {
    _imageUrls = imageUrls;
    [self showAdvertisement];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof(self) weakSelf = self;
    if (self.bannerScroller != nil) {
        [self.bannerScroller setTotalPageCount:^ NSInteger{
            return weakSelf.imageUrls.count;
        }];
    }
    
}

- (void)jumpToTabbar  {
    AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([AccountManager sharedInstance].isLogin) {
        YLUITabBarViewController * tabarVC = [[YLUITabBarViewController alloc] initWithChildVCInfoArray:  nil];
             AppDele.window.rootViewController = tabarVC;
         POST_SOCKETCONNET_NOTIFICATION;
    }else{
        POST_LOGINQUIT_NOTIFICATION;
    }

    //    if (AppDele.isUpdate)
    //    {
    //        [YLHintView showMessageOnThisPage: @"需要更新版本，才能继续使用"];
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/fu-tian-xia/id1095129585"]];//更新
    //    }
    //    else
    //    {
    //
    //    }
    
     
    
    
}

- (void)showAdvertisement {
    __weak typeof(self) weakSelf = self;
    NSMutableArray<NSString *> * urls  =  [_imageUrls mutableCopy];
    //    _imageView.image = [UIImage imageNamed:@"Image_ad_log"];
    //    _imageView.frame = CGRectMake(0, 0, 200, 170);
    //    _imageView.center = CGPointMake(qqWidth/2, qqHeight - 85);
    //    [self.view addSubview: _imageView];
    NSTimeInterval interval = 3;
    if (urls.count == 1) {
        interval = 3;
    }
    self.bannerScroller = [[BannerScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) duration:interval urls:urls];
    [self.view addSubview: _bannerScroller];
    
    [self.bannerScroller setTapActionBlock:^(NSInteger index){
        NSLog(@"点击%@",@(index));
    }];
    
    [self.bannerScroller setEndActionBlock:^{
        [weakSelf jumpToTabbar];
    }];
    
    
}

//获取引导页
-(void)GetAdvertising
{
    
    [self.imageUrl addObject:@"http://pic1.win4000.com/mobile/8/52084a0c27f9e.gif"];
    [self.imageUrl addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542370154375&di=a4d53a756f8d30baf000cd60b4c2e8f0&imgtype=0&src=http%3A%2F%2Fstatic01.coloros.com%2Fbbs%2Fdata%2Fattachment%2Fforum%2F201409%2F01%2F235054mywky0xww24wkkky.png"];
    for (NSString * temp in  self.imageUrl) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:temp]];
        SDImageCache* cache = [SDImageCache sharedImageCache];
        //此方法会先从memory中取。
        NSData  *imageData  = [cache diskImageDataForKey:key];
        if (imageData == NULL) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString: temp] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                [cache storeImageDataToDisk:data forKey: key];
            }];
        }
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.imageUrl forKey:AdvertisementURLs];
//    //AppDelegate *AppDele = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//    //NSString *url = [((AppDelegate *)[[UIApplication sharedApplication] delegate]).Url stringByAppendingString:@"/welcome/ad"];
//    NSString *url = @"https://www.ftxmall.net/api/welcome/ad";
//#if defined(DEBUG)||defined(_DEBUG)
//
//#endif
//
//    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
//     {
//         NSString *errnos = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errno"]];
//
//
//         if([errnos isEqualToString:@"0"])//成功
//         {
//
//             //             for (int i = 0; i < dictionaryArray.count; i++) {
//             //                 NSDictionary * dic = dictionaryArray[i];
//             //                 NSString * imageUrlString =  dic[@"img"];
//             //                 //NSLog(@"img: %@",imageUrlString);
//             //                 [self.imageUrl addObject: imageUrlString];
//             //
//             //
//             //             }
//
//
//         }
//
//
//
//     }
//                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
//     {
//         NSLog(@"请求失败：%@",error);
//
//     }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

