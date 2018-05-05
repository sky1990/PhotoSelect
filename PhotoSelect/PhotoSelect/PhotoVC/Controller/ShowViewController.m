//
//  ShowViewController.m
//  FamilyTree
//
//  Created by shiwei on 17/3/13.
//  Copyright © 2017年 Luanshiwei. All rights reserved.
//

#import "ShowViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ShowViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *imageArray;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation ShowViewController

- (instancetype)initWithImageArray:(NSArray *)imageArray
{
    if (self = [super init]) {
        self.imageArray = imageArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createHeaderView];
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.imageArray.count; i++) {
        if ([self.imageArray[i] class] == [[UIImage new] class]) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = self.imageArray[i];
            [self.scrollView addSubview:imageView];
            if (i == self.imageArray.count - 1) {
                self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.imageArray.count, SCREEN_HEIGHT - 64);
            }

        }else{
            ALAsset *imageAsset = self.imageArray[i];
            //显示原图
            ALAssetRepresentation *representation = [imageAsset defaultRepresentation];
            UIImage *thumbImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
            
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = thumbImage;
            [self.scrollView addSubview:imageView];
            if (i == self.imageArray.count - 1) {
                self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.imageArray.count, SCREEN_HEIGHT - 64);
            }
        }
    }
}

#pragma mark 创建HeaderView
-(void)createHeaderView
{
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    //设置取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(5, 30, 24, 24);
    [cancelBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:cancelBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    titleLabel.text = @"图片预览";
//    [NSString stringWithFormat:@"1/%ld",self.imageArray.count];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font =  [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment =  NSTextAlignmentCenter;
//    self.titleLabel = titleLabel;
    [navigationView addSubview:titleLabel];
    
}

- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    self.titleLabel.text = [NSString stringWithFormat:@"%.lf/%ld",((scrollView.contentOffset.x + SCREEN_WIDTH) / SCREEN_WIDTH), self.imageArray.count];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
