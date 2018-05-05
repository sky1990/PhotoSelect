//
//  ImageButton.m
//  TipGuest
//
//  Created by shiwei on 16/9/28.
//  Copyright © 2016年 Luanshiwei. All rights reserved.
//

#import "ImageButton.h"

@implementation ImageButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(self.frame.size.width - 25, 5, 20, 20);
}

@end
