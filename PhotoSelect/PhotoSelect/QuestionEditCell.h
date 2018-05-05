//
//  QuestionEditCell.h
//  JoyPany
//
//  Created by shiwei on 2017/8/4.
//  Copyright © 2017年 Luanshiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionEditCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *contentImageView;

@property (strong, nonatomic) UIButton *deleteButton;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (copy, nonatomic) void (^deleteImageBlock)(NSIndexPath *indexPath);

@end
