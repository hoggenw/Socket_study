//
//  YLPhotoPreviewController.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/30.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLPhotoPreviewController.h"
#import "ChatMessageModel.h"
#import "YLPhotoPreviewCell.h"


@interface YLPhotoPreviewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation YLPhotoPreviewController


#pragma mark - Override Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.collectionView];
    self.view.clipsToBounds = true;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.width + 20) * _currentIndex, 0) animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Public Methods


#pragma mark - Events


#pragma mark - Private Methods

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.view.width + 20, self.view.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.width + 20, self.view.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.width + 20), 0);
        [_collectionView registerClass:[YLPhotoPreviewCell class] forCellWithReuseIdentifier:@"YLPhotoPreviewCell"];
    }
    return _collectionView;
}


#pragma mark - Extension Delegate or Protocol

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.width + 20);
    
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
    }
}
#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YLPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YLPhotoPreviewCell" forIndexPath:indexPath];
    ChatMessageModel * model = _models[indexPath.row];
    if (model.imagePath != nil) {
        cell.imageUrl = model.imagePath;
    }else if(model.imageURL != nil) {
        cell.imageUrl = model.imageURL;
    }
    
    __weak typeof(self) weakSelf = self;
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(CGRect imageRect) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    if (!cell.longPressGestureBlock) {
        cell.longPressGestureBlock = ^(UIImage *image) {
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"保存图片到相册" message: nil preferredStyle: UIAlertControllerStyleActionSheet];
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"保存" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [YLHintView showMessageOnThisPage:@"图片已保存到相册"];
                    });
                });
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction: sure];
            [alertVC addAction: cancelAction];
            [weakSelf presentViewController: alertVC animated: true completion:nil];
        };
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[YLPhotoPreviewCell class]]) {
        [(YLPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[YLPhotoPreviewCell class]]) {
        [(YLPhotoPreviewCell *)cell recoverSubviews];
    }
}

@end

























