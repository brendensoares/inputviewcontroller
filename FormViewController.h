//
//  FormViewController.h
//
//  Created by Brenden Soares on 11/15/13.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UITextField *activeTextField;
@property (assign, nonatomic) BOOL isKeyboardShowing;
@property (assign, nonatomic) CGRect keyboardFrame;

- (void)scrollToField;
- (void)scrollToDefault;

- (void)dismissKeyboard;

@end
