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

@implementation RMUniversalAlert

+ (id)showAlertInViewController:(UIViewController *)viewController
                      withTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSArray *)otherButtonTitles
                       tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{
    if ([UIAlertController class]) {
        return [UIAlertController showAlertInViewController:viewController
                                                  withTitle:title message:message
                                          cancelButtonTitle:cancelButtonTitle
                                     destructiveButtonTitle:destructiveButtonTitle
                                          otherButtonTitles:otherButtonTitles
                                                   tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                       if (tapBlock) {
                                                           tapBlock(buttonIndex);
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
        
        return [UIAlertView showWithTitle:title
                                  message:message
                        cancelButtonTitle:cancelButtonTitle
                        otherButtonTitles:other
                                 tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex){
                                     if (tapBlock) {
                                         if (buttonIndex == alertView.cancelButtonIndex) {
                                             tapBlock(UIAlertControllerBlocksCancelButtonIndex);
                                         } else if (destructiveButtonTitle) {
                                             if (buttonIndex == alertView.firstOtherButtonIndex) {
                                                 tapBlock(UIAlertControllerBlocksDestructiveButtonIndex);
                                             } else if (otherButtonTitles.count) {
                                                 NSInteger otherOffset = buttonIndex - alertView.firstOtherButtonIndex;
                                                 tapBlock(UIAlertControllerBlocksFirstOtherButtonIndex + otherOffset - 1);
                                             }
                                         } else if (otherButtonTitles.count) {
                                             NSInteger otherOffset = buttonIndex - alertView.firstOtherButtonIndex;
                                             tapBlock(UIAlertControllerBlocksFirstOtherButtonIndex + otherOffset);
                                         }
                                     }
                                 }];
    }
}

+ (id)showActionSheetInViewController:(UIViewController *)viewController
                            withTitle:(NSString *)title
                              message:(NSString *)message
                    cancelButtonTitle:(NSString *)cancelButtonTitle
               destructiveButtonTitle:(NSString *)destructiveButtonTitle
                    otherButtonTitles:(NSArray *)otherButtonTitles
                             tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{
    if ([UIAlertController class]) {
        return [UIAlertController showActionSheetInViewController:viewController
                                                        withTitle:title
                                                          message:message
                                                cancelButtonTitle:cancelButtonTitle
                                           destructiveButtonTitle:destructiveButtonTitle
                                                otherButtonTitles:otherButtonTitles
                                                         tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                             if (tapBlock) {
                                                                 tapBlock(buttonIndex);
                                                             }
                                                         }];
    } else {
        return [UIActionSheet showInView:viewController.view
                               withTitle:title
                       cancelButtonTitle:cancelButtonTitle
                  destructiveButtonTitle:destructiveButtonTitle
                       otherButtonTitles:otherButtonTitles
                                tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                                    if (tapBlock) {
                                        if (buttonIndex == actionSheet.cancelButtonIndex) {
                                            tapBlock(UIAlertControllerBlocksCancelButtonIndex);
                                        } else if (buttonIndex == actionSheet.destructiveButtonIndex) {
                                            tapBlock(UIAlertControllerBlocksDestructiveButtonIndex);
                                        } else if (otherButtonTitles.count) {
                                            NSInteger otherOffset = buttonIndex - actionSheet.firstOtherButtonIndex;
                                            tapBlock(UIAlertControllerBlocksFirstOtherButtonIndex + otherOffset);
                                        }
                                    }
                                }];
    }
}

@end
