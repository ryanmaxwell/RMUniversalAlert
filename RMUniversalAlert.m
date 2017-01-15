//
//  RMUniversalAlert.m
//  RMUniversalAlert
//
//  Created by Ryan Maxwell on 19/11/14.
//  Copyright (c) 2014 Ryan Maxwell. All rights reserved.
//

#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertController+Blocks.h"

#import "objc/runtime.h"

#import "RMUniversalAlert.h"

static NSInteger const RMUniversalAlertNoButtonExistsIndex = -1;

static NSInteger const RMUniversalAlertCancelButtonIndex = 0;
static NSInteger const RMUniversalAlertDestructiveButtonIndex = 1;
static NSInteger const RMUniversalAlertFirstOtherButtonIndex = 2;

@interface RMUniversalAlert ()

@property (nonatomic) UIAlertController *alertController;
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic) UIActionSheet *actionSheet;

@property (nonatomic, assign) BOOL hasCancelButton;
@property (nonatomic, assign) BOOL hasDestructiveButton;
@property (nonatomic, assign) BOOL hasOtherButtons;

@end

@implementation RMUniversalAlert

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(RMUniversalAlertCompletionBlock)tapBlock
{
    RMUniversalAlert *alert = [[RMUniversalAlert alloc] init];
    
    alert.hasCancelButton = cancelButtonTitle != nil;
    alert.hasDestructiveButton = destructiveButtonTitle != nil;
    alert.hasOtherButtons = otherButtonTitles.count > 0;
    
    __weak RMUniversalAlert *weakAlert = alert;
    __weak UIViewController *weakViewController = viewController;
    NSString *alertRefString = [NSString stringWithFormat:@"%p",alert];
    objc_setAssociatedObject(viewController, (__bridge void *)alertRefString, alert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if ([UIAlertController class]) {
        alert.alertController = [UIAlertController showAlertInViewController:viewController
                                                                   withTitle:title message:message
                                                           cancelButtonTitle:cancelButtonTitle
                                                      destructiveButtonTitle:destructiveButtonTitle
                                                           otherButtonTitles:otherButtonTitles
                                                                    tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                                        __strong RMUniversalAlert *strongAlert = weakAlert;
                                                                        __strong UIViewController *strongViewController = weakViewController;
                                                                        if (tapBlock) {
                                                                            tapBlock(strongAlert, buttonIndex);
                                                                        }
                                                                        objc_setAssociatedObject(strongViewController, (__bridge void *)alertRefString, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                                    }];
    } else {
        NSMutableArray *other = [NSMutableArray array];
        
        if (destructiveButtonTitle) {
            [other addObject:destructiveButtonTitle];
        }
        
        if (otherButtonTitles) {
            [other addObjectsFromArray:otherButtonTitles];
        }
        
        alert.alertView =  [UIAlertView showWithTitle:title
                                              message:message
                                    cancelButtonTitle:cancelButtonTitle
                                    otherButtonTitles:other
                                             tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex){
                                                 __strong RMUniversalAlert *strongAlert = weakAlert;
                                                 __strong UIViewController *strongViewController = weakViewController;
                                                 if (tapBlock) {
                                                     if (buttonIndex == alertView.cancelButtonIndex) {
                                                         tapBlock(strongAlert, RMUniversalAlertCancelButtonIndex);
                                                     } else if (destructiveButtonTitle) {
                                                         if (buttonIndex == alertView.firstOtherButtonIndex) {
                                                             tapBlock(strongAlert, RMUniversalAlertDestructiveButtonIndex);
                                                         } else if (otherButtonTitles.count) {
                                                             NSInteger otherOffset = buttonIndex - alertView.firstOtherButtonIndex;
                                                             tapBlock(strongAlert, RMUniversalAlertFirstOtherButtonIndex + otherOffset - 1);
                                                         }
                                                     } else if (otherButtonTitles.count) {
                                                         NSInteger otherOffset = buttonIndex - alertView.firstOtherButtonIndex;
                                                         tapBlock(strongAlert, RMUniversalAlertFirstOtherButtonIndex + otherOffset);
                                                     }
                                                 }
                                                 objc_setAssociatedObject(strongViewController, (__bridge void *)alertRefString, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                             }];
    }
    return alert;
}

+ (instancetype)showActionSheetInViewController:(UIViewController *)viewController
                                      withTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                              otherButtonTitles:(NSArray *)otherButtonTitles
             popoverPresentationControllerBlock:(void(^)(RMPopoverPresentationController *popover))popoverPresentationControllerBlock
                                       tapBlock:(RMUniversalAlertCompletionBlock)tapBlock
{
    RMUniversalAlert *alert = [[RMUniversalAlert alloc] init];
    
    alert.hasCancelButton = cancelButtonTitle != nil;
    alert.hasDestructiveButton = destructiveButtonTitle != nil;
    alert.hasOtherButtons = otherButtonTitles.count > 0;
    
    __weak RMUniversalAlert *weakAlert = alert;
    __weak UIViewController *weakViewController = viewController;
    NSString *alertRefString = [NSString stringWithFormat:@"%p",alert];
    objc_setAssociatedObject(viewController, (__bridge void *)alertRefString, alert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if ([UIAlertController class]) {
        
        alert.alertController = [UIAlertController showActionSheetInViewController:viewController
                                                                         withTitle:title
                                                                           message:message
                                                                 cancelButtonTitle:cancelButtonTitle
                                                            destructiveButtonTitle:destructiveButtonTitle
                                                                 otherButtonTitles:otherButtonTitles
                                                popoverPresentationControllerBlock:^(UIPopoverPresentationController *popover){
                                                    if (popoverPresentationControllerBlock) {
                                                        RMPopoverPresentationController *configuredPopover = [RMPopoverPresentationController new];
                                                        
                                                        popoverPresentationControllerBlock(configuredPopover);
                                                        
                                                        popover.sourceView = configuredPopover.sourceView;
                                                        popover.sourceRect = configuredPopover.sourceRect;
                                                        popover.barButtonItem = configuredPopover.barButtonItem;
                                                    }
                                                }
                                                                          tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                                              __strong RMUniversalAlert *strongAlert = weakAlert;
                                                                              __strong UIViewController *strongViewController = weakViewController;
                                                                              if (tapBlock) {
                                                                                  tapBlock(strongAlert, buttonIndex);
                                                                              }
                                                                              objc_setAssociatedObject(strongViewController, (__bridge void *)alertRefString, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                                          }];
    } else {
        
        void(^actionSheetTapBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex) = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            __strong RMUniversalAlert *strongAlert = weakAlert;
            __strong UIViewController *strongViewController = weakViewController;
            if (tapBlock) {
                if (buttonIndex == actionSheet.cancelButtonIndex) {
                    tapBlock(strongAlert, RMUniversalAlertCancelButtonIndex);
                } else if (buttonIndex == actionSheet.destructiveButtonIndex) {
                    tapBlock(strongAlert, RMUniversalAlertDestructiveButtonIndex);
                } else if (otherButtonTitles.count) {
                    NSInteger otherOffset = buttonIndex - actionSheet.firstOtherButtonIndex;
                    tapBlock(strongAlert, RMUniversalAlertFirstOtherButtonIndex + otherOffset);
                }
            }
            objc_setAssociatedObject(strongViewController, (__bridge void *)alertRefString, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        };
        
        void (^standardActionSheetBlock)(void) = ^{
            __strong RMUniversalAlert *strongAlert = weakAlert;
            __strong UIViewController *strongViewController = weakViewController;
            strongAlert.actionSheet =  [UIActionSheet showInView:strongViewController.view
                                                       withTitle:title
                                               cancelButtonTitle:cancelButtonTitle
                                          destructiveButtonTitle:destructiveButtonTitle
                                               otherButtonTitles:otherButtonTitles
                                                        tapBlock:actionSheetTapBlock];
            objc_setAssociatedObject(strongViewController, (__bridge void *)alertRefString, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        };
        
        if (popoverPresentationControllerBlock) {
            
            RMPopoverPresentationController *configuredPopover = [RMPopoverPresentationController new];
            
            popoverPresentationControllerBlock(configuredPopover);
            
            if (configuredPopover.barButtonItem) {
                alert.actionSheet = [UIActionSheet showFromBarButtonItem:configuredPopover.barButtonItem
                                                                animated:YES
                                                               withTitle:title
                                                       cancelButtonTitle:cancelButtonTitle
                                                  destructiveButtonTitle:destructiveButtonTitle
                                                       otherButtonTitles:otherButtonTitles
                                                                tapBlock:actionSheetTapBlock];
            } else if (configuredPopover.sourceView) {
                alert.actionSheet = [UIActionSheet showFromRect:configuredPopover.sourceRect
                                                         inView:configuredPopover.sourceView
                                                       animated:YES
                                                      withTitle:title
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destructiveButtonTitle
                                              otherButtonTitles:otherButtonTitles
                                                       tapBlock:actionSheetTapBlock];
            } else {
                standardActionSheetBlock();
            }
        } else {
            standardActionSheetBlock();
        }
    }
    
    return alert;
}

#pragma mark -

-(void)dismissAlertAnimated:(BOOL)animated {
    
    if (self.alertController) {
        [self.alertController dismissViewControllerAnimated:animated completion:nil];
    } else if (self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:animated];
    } else if (self.actionSheet) {
        [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
    }
}

- (BOOL)visible
{
    if (self.alertController) {
        return self.alertController.visible;
    } else if (self.alertView) {
        return self.alertView.visible;
    } else if (self.actionSheet) {
        return self.actionSheet.visible;
    }
    NSAssert(false, @"Unsupported alert.");
    return NO;
}

- (NSInteger)cancelButtonIndex
{
    if (!self.hasCancelButton) {
        return RMUniversalAlertNoButtonExistsIndex;
    }
    
    return RMUniversalAlertCancelButtonIndex;
}

- (NSInteger)firstOtherButtonIndex
{
    if (!self.hasOtherButtons) {
        return RMUniversalAlertNoButtonExistsIndex;
    }
    
    return RMUniversalAlertFirstOtherButtonIndex;
}

- (NSInteger)destructiveButtonIndex
{
    if (!self.hasDestructiveButton) {
        return RMUniversalAlertNoButtonExistsIndex;
    }
    
    return RMUniversalAlertDestructiveButtonIndex;
}

@end
