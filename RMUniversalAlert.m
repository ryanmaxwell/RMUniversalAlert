//
//  RMUniversalAlert.m
//  RMUniversalAlert
//
//  Created by Ryan Maxwell on 19/11/14.
//  Copyright (c) 2014 Ryan Maxwell. All rights reserved.
//

#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import <UIActionSheet+Blocks/UIActionSheet+Blocks.h>

#import "RMUniversalAlert.h"

@interface RMUniversalAlert ()

@property (nonatomic) UIAlertController *alertController;
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic) UIActionSheet *actionSheet;

@end

@implementation RMUniversalAlert

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(RMUniversalAlertTapBlock)tapBlock
{
    RMUniversalAlert *alert = [[RMUniversalAlert alloc] init];
    
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
                                                         tapBlock(alert, UIAlertControllerBlocksCancelButtonIndex);
                                                     } else if (destructiveButtonTitle) {
                                                         if (buttonIndex == alertView.firstOtherButtonIndex) {
                                                             tapBlock(alert, UIAlertControllerBlocksDestructiveButtonIndex);
                                                         } else if (otherButtonTitles.count) {
                                                             NSInteger otherOffset = buttonIndex - alertView.firstOtherButtonIndex;
                                                             tapBlock(alert, UIAlertControllerBlocksFirstOtherButtonIndex + otherOffset - 1);
                                                         }
                                                     } else if (otherButtonTitles.count) {
                                                         NSInteger otherOffset = buttonIndex - alertView.firstOtherButtonIndex;
                                                         tapBlock(alert, UIAlertControllerBlocksFirstOtherButtonIndex + otherOffset);
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
                                       tapBlock:(RMUniversalAlertTapBlock)tapBlock
{
    RMUniversalAlert *alert = [[RMUniversalAlert alloc] init];
    
    if ([UIAlertController class]) {
        alert.alertController = [UIAlertController showActionSheetInViewController:viewController
                                                                         withTitle:title
                                                                           message:message
                                                                 cancelButtonTitle:cancelButtonTitle
                                                            destructiveButtonTitle:destructiveButtonTitle
                                                                 otherButtonTitles:otherButtonTitles
                                                                          tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                                              if (tapBlock) {
                                                                                  tapBlock(alert, buttonIndex);
                                                                              }
                                                                          }];
    } else {
        alert.actionSheet =  [UIActionSheet showInView:viewController.view
                                             withTitle:title
                                     cancelButtonTitle:cancelButtonTitle
                                destructiveButtonTitle:destructiveButtonTitle
                                     otherButtonTitles:otherButtonTitles
                                              tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                                                  if (tapBlock) {
                                                      if (buttonIndex == actionSheet.cancelButtonIndex) {
                                                          tapBlock(alert, UIAlertControllerBlocksCancelButtonIndex);
                                                      } else if (buttonIndex == actionSheet.destructiveButtonIndex) {
                                                          tapBlock(alert, UIAlertControllerBlocksDestructiveButtonIndex);
                                                      } else if (otherButtonTitles.count) {
                                                          NSInteger otherOffset = buttonIndex - actionSheet.firstOtherButtonIndex;
                                                          tapBlock(alert, UIAlertControllerBlocksFirstOtherButtonIndex + otherOffset);
                                                      }
                                                  }
                                              }];
    }
    
    return alert;
}

#pragma mark -

- (BOOL)visible
{
    if (self.alertController) {
        return self.alertController.view.superview ? YES : NO;
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
    return UIAlertControllerBlocksCancelButtonIndex;
}

- (NSInteger)firstOtherButtonIndex
{
    return UIAlertControllerBlocksFirstOtherButtonIndex;
}

- (NSInteger)destructiveButtonIndex
{
    return UIAlertControllerBlocksDestructiveButtonIndex;
}

@end
