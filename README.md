RMUniversalAlert
================

Wrapper class for UIAlertController / UIAlertView / UIAlertController for targeting all iOS versions.

RMUniversalAlert is a wrapper class that builds upon [UIAlertView+Blocks](https://github.com/ryanmaxwell/UIAlertView-Blocks), [UIActionSheet+Blocks](https://github.com/ryanmaxwell/UIActionSheet-Blocks), and [UIAlertController+Blocks](https://github.com/ryanmaxwell/UIAlertController-Blocks), and gives a simplified interface to support all iOS versions.

e.g. The below code will show an alert on all iOS versions, and allow you to perform your logic in a single inline code path. 
On iOS 8 and above, it will use UIAlertController - giving you red text on the destructive button. On iOS 7 and earlier, it will use a standard UIAlertView.

```objc
[RMUniversalAlert showAlertInViewController:self
                                  withTitle:@"Title"
                                    message:@"Message"
                          cancelButtonTitle:@"Cancel"
                     destructiveButtonTitle:@"Delete"
                          otherButtonTitles:@[@"Other 1", @"Other 2"]
                                   tapBlock:^(NSInteger buttonIndex){
                                       if (buttonIndex == UIAlertControllerBlocksDestructiveButtonIndex) {
                                           /* Delete */
                                       } else if (buttonIndex == UIAlertControllerBlocksCancelButtonIndex) {
                                           /* Cancel */
                                       } else if (buttonIndex == UIAlertControllerBlocksFirstOtherButtonIndex) {
                                           /* Other 1 */
                                       } else {
                                           /* Other 2 */
                                       }
                                   };
```

## Usage 

`pod 'RMUniversalAlert'` using CocoaPods.

## Examples

Download this project, navigate to `Tests` and run `pod install`. Open `RMUniversalAlert.xcworkspace`. 