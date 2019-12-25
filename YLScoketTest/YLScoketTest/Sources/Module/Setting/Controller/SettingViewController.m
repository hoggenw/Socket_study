//
//  SettingViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/25.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "SettingViewController.h"
#import "SetView.h"
#import "SetViewModel.h"

@interface SettingViewController ()
@property (nonatomic, retain)SetView *setView;
@property (nonatomic, retain)SetViewModel *viewModel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"设置";
    @weakify(self)
    self.setView = [[SetView alloc]init];
    [self.view addSubview:self.setView];
    [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.left.bottom.right.equalTo(self.view);
    }];
     self.viewModel = [[SetViewModel alloc]init];
    [[self.setView rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
        RACTupleUnpack(UITableView *tableView,NSIndexPath *indexPath) =x;
#pragma clang diagnostic pop
        NSDictionary *dataDict = self.viewModel.setData[indexPath.section][indexPath.row];
        
        NSString *pushController = dataDict[@"pushController"];
        if (pushController&&[pushController length]>0&&[[[NSClassFromString(pushController) alloc]init] isKindOfClass:[UIViewController class]]) {
            if ([pushController isEqualToString:@"KYProtocalViewController"]) {
                
            }else{
                UIViewController *controller =[[NSClassFromString(pushController) alloc] init];
                PUSH(controller);
            }
            
        }else{
            if (indexPath.section == 0&& indexPath.row == 1) {
                
                
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message: @"确定要清楚缓存的数据吗？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    for (NSString *fileName in files)
                    {
                        NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
                        [fileManager removeItemAtPath:fileAbsolutePath error:nil];
                    }
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
                    [[SDImageCache sharedImageCache] clearMemory];
                    self.viewModel = [SetViewModel new];
                    self.setView.dataSource = self.viewModel.setData;
                    
                    //                NSString *checkSaveDirectory = [DOCUMENT_PATH stringByAppendingPathComponent:File_CheckOrDiagnosis_Save];
                    //                NSArray *contents = [fileManager contentsOfDirectoryAtPath:checkSaveDirectory error:NULL];
                    //                NSEnumerator *e = [contents objectEnumerator];
                    //                NSString *filename;
                    //                while ((filename = [e nextObject])) {
                    //                    [fileManager removeItemAtPath:[checkSaveDirectory stringByAppendingPathComponent:filename] error:NULL];
                    //                }
                    
                    [YLHintView showMessageOnThisPage:@"缓存清除成功"];
                }];
                
                UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
                [window.rootViewController presentViewController:alertController animated:YES completion:nil];
                
                
            }
        }
        
        
    }];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [[self.setView rac_signalForSelector:@selector(logoutBtnClicked)] subscribeNext:^(RACTuple * _Nullable x) {
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message: @"确定退出当前账户吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.viewModel quitLogin];
        }];
        
        UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }];
#pragma clang diagnostic pop
    [self.viewModel.quitLoginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"退出登录");
        POST_LOGINQUIT_NOTIFICATION;
    }];
    
    
   
    self.setView.dataSource = self.viewModel.setData;
}



@end
