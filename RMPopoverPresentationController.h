//
//  RMPopoverPresentationController.h
//  RMUniversalAlert
//
//  Created by Ryan Maxwell on 10/01/15.
//  Copyright (c) 2015 Ryan Maxwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMPopoverPresentationController : NSObject

@property(nonatomic, strong) UIBarButtonItem *barButtonItem;
@property(nonatomic, strong) UIView *sourceView;
@property(nonatomic, assign) CGRect sourceRect;

@end
