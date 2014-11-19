//
//  RMUniversalAlert.h
//  RMUniversalAlert
//
//  Created by Ryan Maxwell on 19/11/14.
//  Copyright (c) 2014 Ryan Maxwell. All rights reserved.
//

#import <UIAlertController+Blocks/UIAlertController+Blocks.h>

@interface RMUniversalAlert : NSObject

+ (void)showAlertInViewController:(UIViewController *)viewController
                        withTitle:(NSString *)title
                          message:(NSString *)message
                cancelButtonTitle:(NSString *)cancelButtonTitle
           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                otherButtonTitles:(NSArray *)otherButtonTitles
                         tapBlock:(void (^)(NSInteger buttonIndex))tapBlock;

+ (void)showActionSheetInViewController:(UIViewController *)viewController
                              withTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSArray *)otherButtonTitles
                               tapBlock:(void (^)(NSInteger buttonIndex))tapBlock;

@end
