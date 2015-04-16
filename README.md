RMUniversalAlert
================

Wrapper class for UIAlertView / UIActionSheet / UIAlertController for targeting all iOS versions.

RMUniversalAlert is a wrapper class that builds upon [UIAlertView+Blocks](https://github.com/ryanmaxwell/UIAlertView-Blocks), [UIActionSheet+Blocks](https://github.com/ryanmaxwell/UIActionSheet-Blocks), and [UIAlertController+Blocks](https://github.com/ryanmaxwell/UIAlertController-Blocks), and gives a simplified interface to support all iOS versions.

## Interface

```objc
typedef void(^RMUniversalAlertCompletionBlock)(RMUniversalAlert *alert, NSInteger buttonIndex);
```

### Alert Views

```objc
+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(RMUniversalAlertCompletionBlock)tapBlock;
```

### Action Sheets

```objc
+ (instancetype)showActionSheetInViewController:(UIViewController *)viewController
                                      withTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                              otherButtonTitles:(NSArray *)otherButtonTitles
             popoverPresentationControllerBlock:(void(^)(RMPopoverPresentationController *popover))popoverPresentationControllerBlock
                                       tapBlock:(RMUniversalAlertCompletionBlock)tapBlock;
```

## Usage - Alert Views

The below code will show an alert on all iOS versions, and allow you to perform your logic in a single inline code path. 
On iOS 8 and above, it will use UIAlertController - giving you red text on the destructive button. On iOS 7 and earlier, it will use a standard UIAlertView.

### Objective-C

```objc
[RMUniversalAlert showAlertInViewController:self
                                  withTitle:@"Test Alert"
                                    message:@"Test Message"
                          cancelButtonTitle:@"Cancel"
                     destructiveButtonTitle:@"Delete"
                          otherButtonTitles:@[@"First Other", @"Second Other"]
                                   tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
                                       if (buttonIndex == alert.cancelButtonIndex) {
                                           NSLog(@"Cancel Tapped");
                                       } else if (buttonIndex == alert.destructiveButtonIndex) {
                                           NSLog(@"Delete Tapped");
                                       } else if (buttonIndex >= alert.firstOtherButtonIndex) {
                                           NSLog(@"Other Button Index %ld", (long)buttonIndex - alert.firstOtherButtonIndex);
                                       }
                                   };
```

### Swift

```swift
RMUniversalAlert.showAlertInViewController(self,
    withTitle: "Test Alert",
    message: "Test Message",
    cancelButtonTitle: "Cancel",
    destructiveButtonTitle: "Delete",
    otherButtonTitles: ["First Other", "Second Other"],
    tapBlock: {(alert, buttonIndex) in
        if (buttonIndex == alert.cancelButtonIndex) {
            println("Cancel Tapped")
        } else if (buttonIndex == alert.destructiveButtonIndex) {
            println("Delete Tapped")
        } else if (buttonIndex >= alert.firstOtherButtonIndex) {
            println("Other Button Index \(buttonIndex - alert.firstOtherButtonIndex)")
        }
    })
```

## Requirements

iOS 6 and later. Since version 0.7 the headers use the new Objective-C [nullability annotations](https://developer.apple.com/swift/blog/?id=25) for nicer interoperability with Swift, so you will need Xcode 6.3 or later to compile it.

## Usage - Action Sheet

The below code will show an action sheet on all iOS versions, and allow you to perform your logic in a single inline code path. 
On iOS 8 and above, it will use UIAlertController - giving you red text on the destructive button. On iOS 7 and earlier, it will use a standard UIActionSheet.

The `popoverPresentationControllerBlock` allows you to configure the popover's source view/rect/bar button item if the action sheet will be on an iPad. 

### Objective-C

```objc
[RMUniversalAlert showActionSheetInViewController:self
                                        withTitle:@"Test Action Sheet"
                                          message:@"Test Message"
                                cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:@"Delete"
                                otherButtonTitles:@[@"First Other", @"Second Other"]
               popoverPresentationControllerBlock:^(RMPopoverPresentationController *popover){
                                             popover.sourceView = self.view;
                                             popover.sourceRect = sender.frame;
                                         }
                                         tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
                                             if (buttonIndex == alert.cancelButtonIndex) {
                                                 NSLog(@"Cancel Tapped");
                                             } else if (buttonIndex == alert.destructiveButtonIndex) {
                                                 NSLog(@"Delete Tapped");
                                             } else if (buttonIndex >= alert.firstOtherButtonIndex) {
                                                 NSLog(@"Other Button Index %ld", (long)buttonIndex - alert.firstOtherButtonIndex);
                                             }
                                         };
```

### Swift

```swift
RMUniversalAlert.showActionSheetInViewController(self,
    withTitle: "Test Action Sheet",
    message: "Test Message",
    cancelButtonTitle: "Cancel",
    destructiveButtonTitle: "Delete",
    otherButtonTitles: ["First Other", "Second Other"],
    popoverPresentationControllerBlock: {(popover) in
        popover.sourceView = self.view
        popover.sourceRect = sender.frame
    }
    tapBlock: {(alert, buttonIndex) in
        if (buttonIndex == alert.cancelButtonIndex) {
            println("Cancel Tapped")
        } else if (buttonIndex == alert.destructiveButtonIndex) {
            println("Delete Tapped")
        } else if (buttonIndex >= alert.firstOtherButtonIndex) {
            println("Other Button Index \(buttonIndex - alert.firstOtherButtonIndex)")
        }
    })
```

## Installation

`pod 'RMUniversalAlert'` using CocoaPods.

## Examples

Download this project, navigate to `Tests` and run `pod install`. Open `RMUniversalAlert.xcworkspace`. 
