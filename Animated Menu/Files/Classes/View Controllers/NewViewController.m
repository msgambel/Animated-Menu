// NewViewController.m
//
// Copyright (c) 2012 Michael Sgambelluri.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NewViewController.h"
#import "Global.h"

@implementation NewViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
  if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])){
    
  }
  return self;
}

#pragma mark - View LifeStyle

- (void)viewDidLoad; {
  [super viewDidLoad];
}

#pragma mark - iOS 5.1 and under Rotation Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation; {
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - iOS 6.0 and up Rotation Methods

- (BOOL)shouldAutorotate; {
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations; {
  return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation; {
  return UIInterfaceOrientationPortrait;
}

#pragma mark - Methods

- (IBAction)backToMainMenuButtonPressed:(UIButton *)aButton; {
  [self dismissModalViewControllerAnimated:YES];
}

@end