//
//  ViewControllerWithXib.m
//  BarcodeEAN13GenDemo
//
//  Created by Alexey Strokin on 11/3/14.
//  Copyright (c) 2014 Strokin Alexey. All rights reserved.
//

#import "EAN13ViewControllerWithXib.h"
#import "EAN13AppDelegate.h"
#import <EAN13Barcode/BarCodeEAN13.h>
#import <EAN13Barcode/BarCodeView.h>

@interface EAN13ViewControllerWithXib ()

@property (nonnull, strong, nonatomic) IBOutlet BarCodeView *barcodeView;
@property (nonnull, strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation EAN13ViewControllerWithXib
- (IBAction)applyScale:(UISlider *)sender {
    self.barcodeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f/sender.value, 1.0f/sender.value);
}

- (IBAction)generateAction:(id)sender {
    if (self.textField.text.length == 13)
    {
        [self setNumber:self.textField.text];
        return;
    }
    else if (self.textField.text.length > 0)
    {
        lockAnimationForView(self.textField);
        return;
    }
    [self setNumber:GetNewRandomEAN13BarCode()];
}
- (void)setNumber:(NSString*)newNum
{
    [self.barcodeView setBarCode:newNum];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generateAction:nil];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\u200B"] || [string isEqualToString:@""])
    {
        return YES; // detect backspase/delete
    }
    
    NSCharacterSet *set = [NSCharacterSet decimalDigitCharacterSet];
    if ([string rangeOfCharacterFromSet:set].location == NSNotFound)  return NO; //disallow any other except digits

    NSString *result = [aTextField.text stringByAppendingString:string];
    return result.length <= 13;
}
@end
