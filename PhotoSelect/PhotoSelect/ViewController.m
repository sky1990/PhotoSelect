//
//  ViewController.m
//  PhotoSelect
//
//  Created by shiwei on 2018/5/5.
//  Copyright © 2018年 Luanshiwei. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "ChosePhotoController.h"
#import "QuestionEditCell.h"
#import "UIImage+XH_ScaleSize.h"

#define cellHeight ((SCREEN_WIDTH - 4 * 20) / 4)

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, ChosePhotoControllerDelegate>

//@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *collectionData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片选择demo";
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //上传图片UI
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        //创建CollectionView布局类的对象，UICollectionViewFlowLayout有水平和垂直两种布局方式，如果需要做复杂的而已可以继承UICollectionViewFlowLayout创建自己的布局类
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        //指定布局方式为垂直
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 20;//最小行间距(当垂直布局时是行间距，当水平布局时可以理解为列间距)
        flow.minimumInteritemSpacing = 10;//两个单元格之间的最小间距

        //创建CollectionView并指定布局对象
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        //注册自定义的cell，各参数的含义同UITableViewCell的注册
        [_collectionView registerClass:[QuestionEditCell class] forCellWithReuseIdentifier:@"editCell"];
        // 上拉加载更多
    }
    return _collectionView;
}

- (NSMutableArray *)collectionData {
    
    if (!_collectionData) {
        _collectionData = [NSMutableArray new];
    }
    return _collectionData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- ChosePhotoControllerDelegate

- (void)getPhotos:(NSMutableArray *)photos {

    for (ALAsset *imageAsset in photos) {
        UIImage *thumbImage = [UIImage imageWithCGImage:[imageAsset aspectRatioThumbnail]];
        [self.collectionData addObject:thumbImage];
        [self.collectionView reloadData];
    }
}

#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *originImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *imageData;

        imageData =[originImage resetSizeOfImageDataMethodTwo:originImage maxSize:100];
        
        UIImage *newimage = [UIImage imageWithData:imageData];
        [self.collectionData addObject:newimage];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            //关闭相册界面操作
            [self.collectionView reloadData];
        }];
        
    }
}


#pragma mark --  collectionView代理实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionData.count < 3 ? self.collectionData.count + 1 : 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"editCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    [cell setDeleteImageBlock:^(NSIndexPath *indexPath){
        [weakSelf.collectionData removeObjectAtIndex:indexPath.row];
        [weakSelf.collectionView reloadData];
    }];
    if (indexPath.row == self.collectionData.count) {
        cell.deleteButton.hidden = YES;
        cell.contentImageView.image = [UIImage imageNamed:@"btn_add_img"];
    }else{
        cell.deleteButton.hidden = NO;
        cell.contentImageView.image = self.collectionData[indexPath.row];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellHeight, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.collectionData.count == indexPath.row) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [self presentViewController:alert animated:YES completion:nil];
        //拍摄
        [alert addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){//无权限
                [self showAlertView:@"请在iPhone的设置-隐私中设置相应的权限"];
            }else{
                UIImagePickerController *pickVC = [UIImagePickerController new];
                pickVC.delegate = self;
                pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
                [self.navigationController presentViewController:pickVC animated:YES completion:nil];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }
        }]];
        //从相册选取
        [alert addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            
            if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){//无权限
                [self showAlertView:@"请在iPhone的设置-隐私中设置相应的权限"];
            }else{
                ChosePhotoController *choseVC = [[ChosePhotoController alloc] init];
                choseVC.photoDelegate = self;
                choseVC.seletedPhotoNum = self.collectionData.count;
                [self presentViewController:choseVC animated:YES completion:nil];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }
        }]];
        //返回
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
}

- (void)showAlertView:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
}

@end
