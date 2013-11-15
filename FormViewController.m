//
//  FormViewController.m
//
//  Provides UIScrollView for input fields and automatically scrolls to UITextField with focus. Also, dismisses the keyboard when the root UIView is tapped.
//
//  Notes:
//   You only need a nested UIView in the UIScrollView if the nested content will be taller than the scroll view itself. Make sure the scrollView refers to
//   the UIScrollView instance
//
//  Created by Brenden Soares on 11/15/13.
//

#import "FormViewController.h"

@interface FormViewController ()

@end

@implementation FormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Watch for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithObject:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithObject:) name:UIKeyboardDidHideNotification object:nil];
    
    // Dismisskeyboard on tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    self.scrollView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        // Go to next field by view's tag
        [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyDone) {
        // Hide keyboard
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    if (self.isKeyboardShowing)
    {
        [self scrollToField];
    }
}

#pragma mark - Keyboard methods

- (void)keyboardDidShowWithObject: (NSNotification *)notification
{
    self.isKeyboardShowing = YES;
    NSDictionary *userInfo = [notification userInfo];
    self.keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self scrollToField];
}

- (void)keyboardDidHideWithObject: (NSNotification *)notification
{
    self.isKeyboardShowing = NO;
    [self scrollToDefault];
}

-(void)dismissKeyboard
{
    if (self.isKeyboardShowing) {
        [self.activeTextField resignFirstResponder];
    }
}

#pragma mark - UIScrollView methods

- (void)scrollToField
{
    NSInteger scrollViewOffset = self.scrollView.contentOffset.y;
    CGRect fieldFrame = self.activeTextField.frame;
    CGRect areaCoveredByKeyboard = self.keyboardFrame;
    // Convert to scrollView's coordinates
    areaCoveredByKeyboard = [self.scrollView convertRect:areaCoveredByKeyboard fromView:nil];
    // Calculate fields bottom coordinate
    NSInteger fieldBottom = fieldFrame.origin.y + fieldFrame.size.height;
    
    // Check if the field is being covered by the keyboard
    if (areaCoveredByKeyboard.origin.y < fieldBottom)
    {
        NSInteger scrollToOffset = scrollViewOffset + fieldBottom - areaCoveredByKeyboard.origin.y;
        
        // Add insets so we can scroll
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, scrollToOffset, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        // Scroll to active field
        self.scrollView.contentOffset = CGPointMake(0, scrollViewOffset);
        [self.scrollView setContentOffset:CGPointMake(0.0, scrollToOffset) animated:YES];
    }
}

- (void)scrollToDefault
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

@end
