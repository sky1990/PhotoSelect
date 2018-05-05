//
//  UIImage+Category.m
//  TipGuest
//
//  Created by shiwei on 16/9/28.
//  Copyright © 2016年 Luanshiwei. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)


+(instancetype)stretchableImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    image  = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return image;
}



@end
