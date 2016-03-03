//
//  UIView+LJBExtension.m
//  LJBTopSegmentController
//
//  Created by CookieJ on 16/3/3.
//  Copyright © 2016年 ljunb. All rights reserved.
//

#import "UIView+LJBExtension.h"

@implementation UIView (LJBExtension)

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setOriginX:(CGFloat)originX {
    
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (CGFloat)originX {
    
    return self.frame.origin.x;
}

- (void)setOriginY:(CGFloat)originY {
    
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (CGFloat)originY {
    
    return self.frame.origin.y;
}


- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

@end
