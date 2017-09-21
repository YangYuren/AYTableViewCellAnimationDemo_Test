//
//  UITableViewCell+AYAddAnimations.m
//  TableVeiwAnimationTest
//
//  Created by Yang on 2017/9/21.
//  Copyright © 2017年 Tucodec. All rights reserved.
//

#import "UITableViewCell+AYAddAnimations.h"

@implementation UITableViewCell (AYAddAnimations)


- (void)AY_presentAnimateSlideFromLeft{
    CATransform3D rotation;//3D旋转
    
    rotation = CATransform3DMakeTranslation(0 ,50 ,20);
    // 逆时针旋转
    
    rotation = CATransform3DScale(rotation, 0.5, 0.5, 1);
    rotation.m34 = 1.0/ -600;
    
    self.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.layer.shadowOffset = CGSizeMake(10, 10);
    self.alpha = 0;
    self.layer.transform = rotation;
    
    [UIView beginAnimations:@"rotation" context:NULL];
    
    [UIView setAnimationDuration:0.6];
    self.layer.transform = CATransform3DIdentity;
    self.alpha = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

@end
