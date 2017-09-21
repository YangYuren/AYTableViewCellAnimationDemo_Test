//
//  UITableView+AYAddAnimations.m
//  TableVeiwAnimationTest
//
//  Created by Yang on 2017/9/21.
//  Copyright © 2017年 Tucodec. All rights reserved.
//

#import "UITableView+AYAddAnimations.h"
#import <objc/runtime.h>

@implementation UITableView (AYAddAnimations)
//runtime对TableView动态添加属性
- (AYTableViewAnimationType)ay_reloadAnimationType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

-(void)setAy_reloadAnimationType:(AYTableViewAnimationType)ay_reloadAnimationType{
    objc_setAssociatedObject(self, @selector(ay_reloadAnimationType), @(ay_reloadAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    SEL selectors[] = {
        @selector(reloadData),
    };
    //runtime进行方法交换
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"ay_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)ay_reloadData {
    //切换加载时候的风格
    AYTableViewAnimationType type = self.ay_reloadAnimationType;
    if (type != AYTableViewAnimationTypenNone) {
        [self setContentOffset:self.contentOffset animated:YES];
        NSArray<NSString *> *selNames = [self animationNames];
        NSString *selName = [NSString stringWithFormat:@"ay_animation%@", selNames[type - 1]];
        SEL sel = NSSelectorFromString(selName);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:nil afterDelay:0];
        }
    }
    
    [self ay_reloadData];
}

- (NSArray<NSString *> *)animationNames { // 动画数组   存放相应的动画名字
    NSMutableArray *array = @[].mutableCopy;
    [array addObject:@"SlideFromLeft"];
    [array addObject:@"SlideFromRight"];
    [array addObject:@"Fade"];
    [array addObject:@"Fall"];
    [array addObject:@"Vallum"];
    [array addObject:@"Shake"];
    [array addObject:@"Flip"];
    [array addObject:@"FlipX"];
    [array addObject:@"Balloon"];
    [array addObject:@"BalloonTop"];
    return array.copy;
}

- (void)_finished {
    CGFloat maxContentOffsetY = (self.contentSize.height - self.bounds.size.height);
    if (self.contentOffset.y > maxContentOffsetY) {
        CGPoint p = self.contentOffset;
        p.y = maxContentOffsetY;
        [self setContentOffset:p animated:YES];
    }
}

- (void)ay_animationSlideFromLeft {
    [self ay_animationSlideFromLeft:YES];
}

- (void)ay_animationSlideFromRight {//从右滑到做左边
    [self ay_animationSlideFromLeft:NO];
}

- (void)ay_animationSlideFromLeft:(BOOL)isLeft {//从左滑到做右边
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat transTx = isLeft ? -self.frame.size.width :self.frame.size.width;
        cell.transform = CGAffineTransformMakeTranslation(transTx, 0);
        NSTimeInterval delay = idx * (0.4 / visibleCells.count);
        [UIView animateWithDuration:0.75 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            cell.transform = CGAffineTransformIdentity;//重置位置  （屏幕位置）
            
        } completion:NULL];
    }];
}

- (void)ay_animationFade {//渐变
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.alpha = 0.0;
        NSTimeInterval delay = idx * 0.1;
        [UIView animateWithDuration:0.25 delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)ay_animationVallum {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;//获取tableView可见的cell
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {//遍历每一个cell
        CGFloat transTy = self.frame.size.height;
        cell.transform = CGAffineTransformMakeTranslation(0, transTy);
        NSTimeInterval delay = idx * (0.4 / visibleCells.count);
        [UIView animateWithDuration:0.55 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)ay_animationFall {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat transTy = -self.frame.size.height;
        cell.transform = CGAffineTransformMakeTranslation(0, transTy);
        NSTimeInterval delay = (visibleCells.count - idx) * (0.4 / visibleCells.count);
        [UIView animateWithDuration:0.55 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)ay_animationShake {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat transTy = idx % 2 ? -self.bounds.size.height : self.bounds.size.height;
        cell.transform = CGAffineTransformMakeTranslation(transTy, 0);
        NSTimeInterval delay = idx * 0.025;
        [UIView animateWithDuration:0.75 delay:delay usingSpringWithDamping:0.75 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            cell.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)ay_animationFlip:(BOOL)isX {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.layer.opacity = 0.0;
        cell.layer.transform = isX ? CATransform3DMakeRotation(M_PI, 1, 0, 0) : CATransform3DMakeRotation(M_PI, 0, 1, 0);
        NSTimeInterval delay = idx * (0.4 / visibleCells.count);
        [UIView animateWithDuration:0.55 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.layer.opacity = 1.0;
            cell.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)ay_animationFlip {
    [self ay_animationFlip:NO];
}

- (void)ay_animationFlipX {
    [self ay_animationFlip:YES];
}

- (void)ay_animationBalloon:(BOOL)isToTop {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.layer.opacity = 0.0;
        cell.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
        NSTimeInterval delay = 0;
        if (isToTop) {
            delay = (visibleCells.count - idx) * (0.4 / visibleCells.count);
        } else {
            delay = idx * (0.4 / visibleCells.count);
        }
        
        BOOL isUsingSpring = YES;
        
        if (isUsingSpring) {
            [UIView animateWithDuration:0.75 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.layer.opacity = 1.0;
                cell.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:0.45 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.layer.opacity = 1.0;
                cell.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}

- (void)ay_animationBalloon {
    [self ay_animationBalloon:NO];
}

- (void)ay_animationBalloonTop {
    [self ay_animationBalloon:YES];
}



@end
