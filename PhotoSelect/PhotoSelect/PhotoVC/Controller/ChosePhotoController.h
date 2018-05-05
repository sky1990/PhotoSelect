//
//  ChosePhotoController.h
//  TipGuest
//
//  Created by shiwei on 16/9/28.
//  Copyright © 2016年 Luanshiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PhotoMargin 2 //图片间隙
#define PhotoColumn 4 //每个cell显示4张图片
#define KTagStart 100
#define MaxPhoto 3

@protocol ChosePhotoControllerDelegate <NSObject>

//获取返回的图片
-(void)getPhotos:(NSMutableArray *)photos;

@end

@interface ChosePhotoController : UIViewController

////图片列表
//@property(nonatomic,strong)NSMutableArray *photoArray;
@property (assign, nonatomic) NSUInteger seletedPhotoNum;

@property(nonatomic,strong)id<ChosePhotoControllerDelegate> photoDelegate;

@end
