//
//  QuestionEditCell.m
//  JoyPany
//
//  Created by shiwei on 2017/8/4.
//  Copyright © 2017年 Luanshiwei. All rights reserved.
//

#import "QuestionEditCell.h"

@implementation QuestionEditCell

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.contentImageView = [UIImageView new];
    self.contentImageView.image = [UIImage imageNamed:@"btn_add_img"];
    [self.contentView addSubview:self.contentImageView];
    
    self.deleteButton = [UIButton new];
    [self.deleteButton setImage:[UIImage imageNamed:@"btn_delete2"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView).with.offset(-8);
        make.right.equalTo(self.contentImageView).with.offset(8);
        make.width.height.mas_equalTo(@22);
    }];
}

- (void)deleteClick {
    
    if (self.deleteImageBlock) {
        self.deleteImageBlock(self.indexPath);
    }
}

@end
