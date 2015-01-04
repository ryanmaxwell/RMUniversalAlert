RMUniversalAlert
================

Wrapper class for UIAlertView / UIActionSheet / UIAlertController for targeting all iOS versions.

RMUniversalAlert is a wrapper class that builds upon [UIAlertView+Blocks](https://github.com/ryanmaxwell/UIAlertView-Blocks), [UIActionSheet+Blocks](https://github.com/ryanmaxwell/UIActionSheet-Blocks), and [UIAlertController+Blocks](https://github.com/ryanmaxwell/UIAlertController-Blocks), and gives a simplified interface to support all iOS versions.

## Interface

```objc
typedef void(^RMUniversalAlertCompletionBlock)(RMUniversalAlert *alert, NSInteger buttonIndex);

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                        withTitle:(NSString *)title
                          message:(NSString *)message
                cancelButtonTitle:(NSString *)cancelButtonTitle
           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                otherButtonTitles:(NSArray *)otherButtonTitles
                         tapBlock:(RMUniversalAlertCompletionBlock)tapBlock;

+ (instancetype)showActionSheetInViewController:(UIViewController *)viewController
                              withTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSArray *)otherButtonTitles
                               tapBlock:(RMUniversalAlertCompletionBlock)tapBlock;
```

## Usage 

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
            println("Other Button Index \(buttonIndex - UIAlertControllerBlocksFirstOtherButtonIndex)")
        }
    })
```

## Installation

`pod 'RMUniversalAlert'` using CocoaPods.

## Examples

Download this project, navigate to `Tests` and run `pod install`. Open `RMUniversalAlert.xcworkspace`. 
