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

#import "RMUniversalAlert.h"

static NSInteger const RMUniversalAlertNoButtonExistsIndex = -1;

static NSInteger const RMUniversalAlertCancelButtonIndex = 0;
static NSInteger const RMUniversalAlertDestructiveButtonIndex = 1;
static NSInteger const RMUniversalAlertFirstOtherButtonIndex = 2;

@interface RMUniversalAlert ()

@property (nonatomic,weak) UIAlertController *alertController;
@property (nonatomic,weak) UIAlertView *alertView;
@property (nonatomic,weak) UIActionSheet *actionSheet;

@property (nonatomic, assign) BOOL hasCancelButton;
@property (nonatomic, assign) BOOL hasDestructiveButton;
@property (nonatomic, assign) BOOL hasOtherButtons;

@end

@implementation RMUniversalAlert

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)didEnterBackground {
    [self dismissAlertAnimated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(RMUniversalAlertCompletionBlock)tapBlock
{
//    if ([viewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
//        [viewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//    }
    RMUniversalAlert *alert = [[RMUniversalAlert alloc] init];
    
    alert.hasCancelButton = cancelButtonTitle != nil;
    alert.hasDestructiveButton = destructiveButtonTitle != nil;
    alert.hasOtherButtons = otherButtonTitles.count > 0;
    
    if ([UIAlertController class]) {
        alert.alertController = [UIAlertController showAlertInViewController:viewController
                                                                   withTitle:title message:message
                                                           cancelButtonTitle:cancelButtonTitle
                                                      destructiveButtonTitle:destructiveButtonTitle
                                                           otherButtonTitles:otherButtonTitles
                                                                    tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                                        if (tapBlock) {
                                                                            tapBlock(alert, buttonIndex);
                                                                        }
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
                                                 if (tapBlock) {
                                                     if (buttonIndex == alertView.cancelButtonIndex) {
                                                         tapBlock(alert, RMUniversalAlertCancelButtonIndex);
                                                     } else if (destructiveButtonTitle) {
                                                         if (buttonIndex == alertView.firstOtherButtonIndex) {
                                                             tapBlock(alert, RMUniversalAlertDestructiveButtonIndex);
                                                         } else if (otherButtonTitles.count) {
                                                             NSInteger otherOffset = buttonIndex - alertView.firstOtherButtonIndex;
                                                             tapBlock(alert, RMUniversalAlertFirstOtherButtonIndex + otherOffset - 1);
                                                         }
                                                     } else if (otherButtonTitles.count) {
                                                         NSInteger otherOffset = buttonIndex - alertView.firstOtherButtonIndex;
                                                         tapBlock(alert, RMUniversalAlertFirstOtherButtonIndex + otherOffset);
                                                     }
                                                 }
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
                                                                              if (tapBlock) {
                                                                                  tapBlock(alert, buttonIndex);
                                                                              }
                                                                          }];
    } else {
        
        void(^actionSheetTapBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex) = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            if (tapBlock) {
                if (buttonIndex == actionSheet.cancelButtonIndex) {
                    tapBlock(alert, RMUniversalAlertCancelButtonIndex);
                } else if (buttonIndex == actionSheet.destructiveButtonIndex) {
                    tapBlock(alert, RMUniversalAlertDestructiveButtonIndex);
                } else if (otherButtonTitles.count) {
                    NSInteger otherOffset = buttonIndex - actionSheet.firstOtherButtonIndex;
                    tapBlock(alert, RMUniversalAlertFirstOtherButtonIndex + otherOffset);
                }
            }
        };
        
        void (^standardActionSheetBlock)(void) = ^{
            alert.actionSheet =  [UIActionSheet showInView:viewController.view
                                                 withTitle:title
                                         cancelButtonTitle:cancelButtonTitle
                                    destructiveButtonTitle:destructiveButtonTitle
                                         otherButtonTitles:otherButtonTitles
                                                  tapBlock:actionSheetTapBlock];
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


+ (void)showAlertInViewControllerN:(nonnull UIViewController *)viewController
                                      withMessage:(nullable NSString *)message withBlock:(ShowTipDismissBlock) misBlock {
    
    if ([UIAlertController class]) {
        __block UIAlertController *alertController = [UIAlertController showAlertInViewController:viewController
                                                                   withTitle:nil message:message
                                                           cancelButtonTitle:nil
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:nil
                                                                    tapBlock:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{
                if (misBlock) {
                    misBlock();
                    alertController = nil;
                }
            }];
        });
        
    } else {
        __block UIAlertView *alertView =  [UIAlertView showWithTitle:nil
                                              message:message
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil
                                             tapBlock:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
            if (misBlock) {
                misBlock();
                alertView = nil;
            }
        });
    }
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
