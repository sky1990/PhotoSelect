//
//  ChosePhotoController.m
//  TipGuest
//
//  Created by shiwei on 16/9/28.
//  Copyright © 2016年 Luanshiwei. All rights reserved.
//

#import "ChosePhotoController.h"
#import "UIImage+Category.h"
#import "ImageButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "ShowViewController.h"

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@interface ChosePhotoController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;

//设置cell
@property(nonatomic,assign)NSInteger page;

//图片宽度
@property(nonatomic,assign)CGFloat photoWidth;

//设置选中的值
@property(nonatomic,strong)NSMutableArray *choseArray;

//设置选中图标
@property(nonatomic,strong)NSMutableArray *choseTagArray;

//确定按钮
@property(nonatomic,strong)UIButton *comfirmBtn;

//图片列表
@property(nonatomic,strong)NSMutableArray *photoArray;

@property (weak, nonatomic) UIButton *showButton;

@end


@implementation ChosePhotoController


- (void)viewDidLoad {

    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //初始化选中值数组
    self.choseArray = [NSMutableArray array];
    //初始化选中tag数组
    self.choseTagArray = [NSMutableArray array];
    
    self.photoArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
        });
    });
    
    [self loadLocalPhotos];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToRoot) name:@"backToRoot" object:nil];
}

- (void)backToRoot {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 加载本地相册的所有图片
-(void)loadLocalPhotos {
    
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.labelText = @"加载相册图片...";
    
    //    ALAssetsLibrary  *assetsLibrary = [[ALAssetsLibrary alloc] init];
    ALAssetsLibrary *assetsLibrary = [self defaultAssetsLibrary];
    
    self.photoArray = [NSMutableArray array];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //相册分组 group
        if (group) {
            
            if([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == 16) //表示是系统默认的相册
            {
                
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    if (result) {
                        
                        [self.photoArray addObject:result];
                        
                    }
                    
                }];
                
                NSLog(@"%zd",self.photoArray.count);
            }
            
            [self createHeaderView];
            
            if (self.photoArray.count > 0) {
                [self loadLastMessage];
            }
            
//            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            NSArray *temArray = [myDelegate.selectedPhotosArray mutableCopy];
            
            for (int index = 0; index < [self.photoArray count]; index++) {
                
//                NSString *temStr0 = [NSString stringWithFormat:@"%@",self.photoArray[index]];
//                for (int tt = 0; tt < [temArray count]; tt++) {
//                    NSString *temStr1 = [NSString stringWithFormat:@"%@",temArray[tt]];
//                    if ([temStr0 isEqualToString:temStr1]) {
//                        NSNumber *btnTag = [NSNumber numberWithInt:index+KTagStart];
//                        [self.choseTagArray addObject:btnTag];
//                        [self.choseArray addObject:self.photoArray[index]];
                    }
                }
        
            
//            if(self.choseTagArray.count > 0)
//            {
//                [self.comfirmBtn setUserInteractionEnabled:YES];
//                [self.comfirmBtn setTitle:[NSString stringWithFormat:@"继续(%ld)",self.choseTagArray.count] forState:UIControlStateNormal];
//                [self.comfirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#FB0E38"]];
//                [self.comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            }
//            else
//            {
//                [self.comfirmBtn setUserInteractionEnabled:NO];
//                [self.comfirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#DEDFE1"]];
//                [self.comfirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//                [self.comfirmBtn setTitle:@"继续" forState:UIControlStateNormal];
//            }
     
            
//        }
     
    } failureBlock:^(NSError *error) {
        //图片获取失败
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"--获取图片失败");
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
}

- (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma 计算图片显示宽度
-(CGFloat)photoWidth
{
   if(_photoWidth == 0)
   {
       //图片宽度计算 ＝ （屏幕宽度 - (图片个数 - 1) * 图片之间的间距） /  图片个数
       self.photoWidth = ([UIScreen mainScreen].bounds.size.width - ((PhotoColumn - 1) * PhotoMargin)) / PhotoColumn;
   }
    return _photoWidth;
}

#pragma 计算cell个数
-(NSInteger)page
{
   if(_page == 0)
   {
       NSLog(@"self.photoArray=%@",self.photoArray);
       _page = self.photoArray.count % PhotoColumn == 0 ? self.photoArray.count / PhotoColumn : self.photoArray.count / PhotoColumn + 1;
   }
    return _page;
}


#pragma mark 创建HeaderView
-(void)createHeaderView
{
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
//    navigationView.backgroundColor = [UIColor colorWithRed:0.216f green:0.573f blue:0.824f alpha:1.00f];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    //设置背景图片
//    UIImage *bgImage = [UIImage stretchableImage:@"nav_bg"];
//    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:bgImage];
//    bgImageView.backgroundColor = RGB_COLOR(199, 0, 11);
//    bgImageView.frame = CGRectMake(0, 0, navigationView.bounds.size.width, navigationView.bounds.size.height);
//    [navigationView addSubview:bgImageView];
    
    //设置取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 20, 60, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB_COLOR(252,159,72) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:cancelBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    titleLabel.text = @"相机胶卷";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font =  [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment =  NSTextAlignmentCenter;
    [navigationView addSubview:titleLabel];
    
//    cancelBtn.frame = CGRectMake(self.view.bounds.size.width - 60, 20, 60, 44);
    self.comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.comfirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#DEDFE1"]];
    self.comfirmBtn.frame = CGRectMake(self.view.bounds.size.width - 75, 28, 70, 28);
    [self.comfirmBtn setTitle:@"继续" forState:UIControlStateNormal];
    [self.comfirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.comfirmBtn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    self.comfirmBtn.layer.cornerRadius = 5.0f;
    [self.comfirmBtn setUserInteractionEnabled:NO];
    [navigationView addSubview:self.comfirmBtn];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.frame.size.height - 64 -48) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 246, 247);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsSelection = NO;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 48, SCREEN_WIDTH, 48)];
    tabBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBarView];
    
    UIButton *showButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 64, 48)];
    [showButton setTitle:@"预览" forState:UIControlStateNormal];
    [showButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    showButton.titleLabel.font = [UIFont systemFontOfSize:14];
    showButton.userInteractionEnabled = NO;
    self.showButton = showButton;
    showButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [showButton addTarget:self action:@selector(showClick) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:showButton];
}

#pragma mark 取消
-(void)cancelClick
{
    //弹出对话框
    //是否保存草稿，下次继续编辑？
//    SQLiteManager *manage = [SQLiteManager shareManager];
//    [manage deleteImageTagsAll];

//    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [myDelegate.selectedAssets removeAllObjects];
//    [myDelegate.selectedPhotosArray removeAllObjects];
//    myDelegate.selectedImage = @"0";
    
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)showClick
{
    ShowViewController *showVC = [[ShowViewController alloc] initWithImageArray:self.choseArray];
    [self presentViewController:showVC animated:YES completion:nil];
}



#pragma mark 确定
-(void)comfirmClick
{
    //把选中的图片传回谈出的页面
    if([self.photoDelegate respondsToSelector:@selector(getPhotos:)])
    {
//        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [myDelegate.selectedPhotosArray removeAllObjects];
//        [myDelegate.selectedPhotosArray addObjectsFromArray:self.choseArray];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.photoDelegate getPhotos:self.choseArray];
    }
}


#pragma mark 自动定位到最后信息
-(void)loadLastMessage
{
    NSLog(@"self.page=%ld",self.page);
    if (self.page == 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.page - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



#pragma mark 总共多少条记录
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  self.page;
}

#pragma mark 设置UITableViewCell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSUInteger localtion = indexPath.row * PhotoColumn;
    NSUInteger length = PhotoColumn;
    if(localtion + PhotoColumn > self.photoArray.count)
    {
        length = self.photoArray.count - localtion;
    }
    NSRange range = NSMakeRange(localtion  , length);//截取数组
    NSArray *rangeArray = [self.photoArray subarrayWithRange:range];
    
    return [self addPhotos:cell rangeArray:rangeArray indexPath:indexPath];
    
}

#pragma mark 显示图片
-(UITableViewCell *)addPhotos:(UITableViewCell *)cell rangeArray:(NSArray *)rangeArray indexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < rangeArray.count; i ++ ) {
        ImageButton *btn = [ImageButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            btn.frame = CGRectMake(0, PhotoMargin, self.photoWidth, self.photoWidth);
        }
        else
        {
            btn.frame = CGRectMake(i * (self.photoWidth + PhotoMargin) , PhotoMargin, self.photoWidth, self.photoWidth);
        }
        btn.tag =KTagStart +  indexPath.row * PhotoColumn + i;
//        NSDictionary *dictionary = rangeArray[i];
//        UIImage *thumbImage = dictionary[@"thumbnail"];
        
//        UIImage *thumbImage = rangeArray[i];
        
        ALAsset *imageAsset = rangeArray[i];
//        ALAssetRepresentation *representation = [imageAsset defaultRepresentation];
        UIImage *thumbImage = [UIImage imageWithCGImage:[imageAsset thumbnail]];
        
        [btn setBackgroundImage:thumbImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnChosePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
//        [self.choseTagArray removeAllObjects];
        //处理图片选中(
        if([self.choseTagArray containsObject:[NSNumber numberWithInteger:btn.tag]])
        {
          [btn setImage:[UIImage imageNamed:@"checked_1"] forState:UIControlStateNormal];
        }else [btn setImage:[UIImage imageNamed:@"unchecked_1"] forState:UIControlStateNormal];
        
    }
    
    return cell;

}


#pragma mark 处理选中
-(void)btnChosePhoto:(ImageButton *)btn
{
    
    NSNumber *btnTag = [NSNumber numberWithInteger:btn.tag];
    //设置选中图片
    if([self.choseTagArray containsObject:btnTag])
    {
        [self.choseTagArray removeObject:btnTag];
        [btn setImage:[UIImage imageNamed:@"unchecked_1"] forState:UIControlStateNormal];
    }
    else
    {
        
        if(self.choseTagArray.count >= MaxPhoto - self.seletedPhotoNum)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%ld张照片",MaxPhoto - self.seletedPhotoNum] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [self.choseTagArray addObject:btnTag];
        [btn setImage:[UIImage imageNamed:@"checked_1"] forState:UIControlStateNormal];
    }
    
    if(self.choseTagArray.count > 0)
    {
        [self.comfirmBtn setUserInteractionEnabled:YES];
        [self.comfirmBtn setTitle:[NSString stringWithFormat:@"继续(%ld/%ld)",self.choseTagArray.count, MaxPhoto - self.seletedPhotoNum] forState:UIControlStateNormal];
        [self.comfirmBtn setBackgroundColor:RGB_COLOR(252,159,72)];
        [self.comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.showButton.userInteractionEnabled = YES;
        [self.showButton setTitle:[NSString stringWithFormat:@"预览(%ld)",self.choseTagArray.count] forState:UIControlStateNormal];
        [self.showButton setTitleColor:RGB_COLOR(210, 0, 0) forState:UIControlStateNormal];
    }
    else
    {
        [self.comfirmBtn setUserInteractionEnabled:NO];
        [self.comfirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#DEDFE1"]];
        [self.comfirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.comfirmBtn setTitle:@"继续" forState:UIControlStateNormal];
        
        self.showButton.userInteractionEnabled = NO;
        [self.showButton setTitle:@"预览" forState:UIControlStateNormal];
        [self.showButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
 
    //处理选中的照片的内容(缩略图，全屏图，高清图)
    NSInteger tag = btn.tag - KTagStart;
    
    if([self.choseArray containsObject:self.photoArray[tag]])
    {
        [self.choseArray removeObject:self.photoArray[tag]];
        
    }
    else
    {
        [self.choseArray addObject:self.photoArray[tag]];
    }
    
}


#pragma mark 设置Cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    CGFloat height = ([UIScreen mainScreen].bounds.size.width - ((PhotoColumn - 1) * PhotoMargin)) / PhotoColumn;

    if(indexPath.row == self.page - 1)
    {
        return  height + PhotoMargin * 4;
    }
    return  height + PhotoMargin;
    
}

@end
