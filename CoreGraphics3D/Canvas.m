//
//  Canvas.m
//  CoreGraphics3D
//
//  Created by yoshimura atsushi on 2013/06/18.
//  Copyright (c) 2013年 WOW Inc. All rights reserved.
//

#import "Canvas.h"
#import <QuartzCore/QuartzCore.h>
#import "Teapot.h"

static float remap(float value, float inputMin, float inputMax, float outputMin, float outputMax)
{
    return (value - inputMin) * ((outputMax - outputMin) / (inputMax - inputMin)) + outputMin;
}

@implementation Canvas
{
    CADisplayLink *_displayLink;
    double _time;
}
- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
}
- (void)startAnimation
{
    _displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawRequest:)];
    _displayLink.frameInterval = 1;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    
}
- (void)drawRequest:(CADisplayLink *)sender
{
    _time = sender.timestamp;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [@"CoreGraphics" drawAtPoint:CGPointZero withFont:[UIFont systemFontOfSize:20.0f]];
    
    UIColor *strokeColor = [UIColor redColor];
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetLineWidth(context, 1.0f / [UIScreen mainScreen].scale);
    
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(cos(_time) * 20.0, sin(_time * 0.5) * 10.0, sin(_time) * 20.0, /*eye*/
                                                 0, 0, 0, /*center*/
                                                 0, 1, 0 /*up*/);
    float aspect = self.bounds.size.width / self.bounds.size.height;
    GLKMatrix4 projMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45),
                                                      aspect,
                                                      0.1f,
                                                      100.0f);
    
    GLKMatrix4 transform = GLKMatrix4Multiply(projMatrix, viewMatrix);
    
    
    for(int i = 0 ; i < sizeof(faces) / sizeof(faces[0]) ; ++i)
    {
        Face f = faces[i];
        GLKVector3 points[] = {vertices[f.p1 - 1], vertices[f.p2 - 1], vertices[f.p3 - 1]};
        
        CGMutablePathRef path = CGPathCreateMutable();
        for(int j = 0 ; j < 3 ; ++j)
        {
            GLKVector4 src = GLKVector4Make(points[j].x, points[j].y, points[j].z, 1.0);
            GLKVector4 dst = GLKMatrix4MultiplyVector4(transform, src);
            CGPoint normalized = {dst.x / dst.w, dst.y / dst.w}; /*perspective by divide w*/
            CGPoint display = {
                remap(normalized.x, -1, 1, 0, self.bounds.size.width),
                remap(normalized.y, -1, 1, self.bounds.size.height, 0),
            };
            
            if(j == 0)
            {
                CGPathMoveToPoint(path, NULL, display.x, display.y);
            }
            else
            {
                CGPathAddLineToPoint(path, NULL, display.x, display.y);
            }
        }
        CGPathCloseSubpath(path);
        
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
        CGPathRelease(path);
    }
}

@end
