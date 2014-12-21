RMUniversalAlert
================

Wrapper class for UIAlertView / UIActionSheet / UIAlertController for targeting all iOS versions.

RMUniversalAlert is a wrapper class that builds upon [UIAlertView+Blocks](https://github.com/ryanmaxwell/UIAlertView-Blocks), [UIActionSheet+Blocks](https://github.com/ryanmaxwell/UIActionSheet-Blocks), and [UIAlertController+Blocks](https://github.com/ryanmaxwell/UIAlertController-Blocks), and gives a simplified interface to support all iOS versions.

e.g. The below code will show an alert on all iOS versions, and allow you to perform your logic in a single inline code path. 
On iOS 8 and above, it will use UIAlertController - giving you red text on the destructive button. On iOS 7 and earlier, it will use a standard UIAlertView.

### Objective-C

```objc
[RMUniversalAlert showAlertInViewController:self
                                  withTitle:@"Test Alert"
                                    message:@"Test Message"
                          cancelButtonTitle:@"Cancel"
                     destructiveButtonTitle:@"Delete"
                          otherButtonTitles:@[@"First Other", @"Second Other"]
                                   tapBlock:^(NSInteger buttonIndex){
                                       
                                       if (buttonIndex == UIAlertControllerBlocksCancelButtonIndex) {
                                           NSLog(@"Cancel Tapped");
                                       } else if (buttonIndex == UIAlertControllerBlocksDestructiveButtonIndex) {
                                           NSLog(@"Delete Tapped");
                                       } else if (buttonIndex >= UIAlertControllerBlocksFirstOtherButtonIndex) {
                                           NSLog(@"Other Button Index %ld", (long)buttonIndex - UIAlertControllerBlocksFirstOtherButtonIndex);
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
    tapBlock: {(buttonIndex) in
    
        if (buttonIndex == UIAlertControllerBlocksCancelButtonIndex) {
            println("Cancel Tapped")
        } else if (buttonIndex == UIAlertControllerBlocksDestructiveButtonIndex) {
            println("Delete Tapped")
        } else if (buttonIndex >= UIAlertControllerBlocksFirstOtherButtonIndex) {
            println("Other Button Index \(buttonIndex - UIAlertControllerBlocksFirstOtherButtonIndex)")
        }
    })
```

## Usage 

`pod 'RMUniversalAlert'` using CocoaPods.

## Examples

Download this project, navigate to `Tests` and run `pod install`. Open `RMUniversalAlert.xcworkspace`. 


