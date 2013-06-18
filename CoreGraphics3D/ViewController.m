//
//  ViewController.m
//  CoreGraphics3D
//
//  Created by yoshimura atsushi on 2013/06/18.
//  Copyright (c) 2013年 WOW Inc. All rights reserved.
//

#import "ViewController.h"
#import "Canvas.h"
@implementation ViewController
{
    IBOutlet Canvas *_canvas;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_canvas startAnimation];
}

@end
