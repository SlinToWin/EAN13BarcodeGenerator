//
//  EAN13ViewController.m
//  EAN13Barcode
//
//  Created by Alexey Strokin on 10/02/2016.
//  Copyright (c) 2016 Alexey Strokin. All rights reserved.
//

#import "EAN13ViewController.h"
#import "EAN13AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <EAN13Barcode/BarCodeEAN13.h>
#import <EAN13Barcode/BarCodeView.h>

static const CGRect kLabelFrame = {{0.0, 20.0},{320.0, 30.0}};
static const CGRect kBarCodeFrame = {{103.0, 55.0},{113.0, 100.0}};
static const CGRect kButtonFrame = {{85.0, 220.0},{150.0, 30.0}};
static const CGRect kTextFieldFrame = {{60.0, 170.0},{200.0, 30.0}};

@interface EAN13ViewController () <UITextFieldDelegate>

@property (nonnull, nonatomic, strong) BarCodeView *barCodeView;
@property (nonnull, nonatomic, strong) UIButton *button;
@property (nonnull, nonatomic, strong) UITextField *textField;

@end

@implementation EAN13ViewController

-(void)loadView
{
    CGFloat h =  [UIApplication sharedApplication].statusBarHidden ? 0 :
    [UIApplication sharedApplication].statusBarFrame.size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, h,
                                                            [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - h)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    self.barCodeView = [[BarCodeView alloc] initWithFrame:kBarCodeFrame];
    [view addSubview:self.barCodeView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = kButtonFrame;
    [self.button addTarget:self action:@selector(generate)
     forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Generate" forState:UIControlStateNormal];
    [view addSubview:self.button];
    
    self.textField = [[UITextField alloc] initWithFrame:kTextFieldFrame];
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.delegate = self;
    [view addSubview:self.textField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kLabelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20.0f];
    label.text = @"EAN-13";
    [view addSubview:label];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generate];
}

- (void)setNumber:(NSString*)newNum
{
    [self.barCodeView setBarCode:newNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)generate
{
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
