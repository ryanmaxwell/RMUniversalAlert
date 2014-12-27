//
//  RMUniversalAlert.h
//  RMUniversalAlert
//
//  Created by Ryan Maxwell on 19/11/14.
//  Copyright (c) 2014 Ryan Maxwell. All rights reserved.
//

#import <UIAlertController+Blocks/UIAlertController+Blocks.h>
@class RMUniversalAlert;

typedef void(^RMUniversalAlertTapBlock)(RMUniversalAlert *alert, NSInteger buttonIndex);

@interface RMUniversalAlert : NSObject

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(RMUniversalAlertTapBlock)tapBlock;

+ (instancetype)showActionSheetInViewController:(UIViewController *)viewController
                                      withTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                              otherButtonTitles:(NSArray *)otherButtonTitles
                                       tapBlock:(RMUniversalAlertTapBlock)tapBlock;

- (BOOL)visible;
- (NSInteger)cancelButtonIndex;
- (NSInteger)firstOtherButtonIndex;
- (NSInteger)destructiveButtonIndex;

@end
