// ViewController.m
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

#import "ViewController.h"

@interface ViewController (Private)

- (void)sortButtons;
- (void)expandButtonAtIndex:(uint)aIndex;
- (void)contractButtonAtIndex:(int)aIndex;

@end

@implementation ViewController

@synthesize subMenuButtons = _subMenuButtons;

#pragma mark - View LifeStyle

- (void)viewDidLoad; {
  [super viewDidLoad];
  [self sortButtons];
  _menuButtonCenter = _menuButton.center;
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

- (IBAction)consecutivelyAnimatedMenuButtonPressed:(UIButton *)aButton; {
  if(!_isAnimating){
    if(_isSubMenuExpanded){
      [self contractButtonAtIndex:([_subMenuButtons count] - 1)];
      
      [UIView animateWithDuration:AnimationContractDuration
                            delay:0.0f
                          options:UIViewAnimationCurveEaseInOut
                       animations:^(void){
                         _menuButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         _menuButton.center = _menuButtonCenter;
                       }
                       completion:^(BOOL finished){
                         
                       }];
    }
    else{
      [self expandButtonAtIndex:0];
      
      [UIView animateWithDuration:AnimationExpandDuration
                            delay:0.0f
                          options:UIViewAnimationCurveEaseInOut
                       animations:^(void){
                         _menuButton.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
                         _menuButton.center = _menuButtonCenter;
                       }
                       completion:^(BOOL finished){
                         
                       }];
    }
    _isAnimating = YES;
  }
}

- (IBAction)simultaneouslyAnimatedMenuButtonPressed:(UIButton *)aButton; {
  if(!_isAnimating){
    _isAnimating = YES;
    CGRect temporaryFrame = CGRectZero;
    CGPoint centerPoint = _menuButton.center;
    UIButton * subMenuButton = nil;
    CGRect testButtonStartRect[[_subMenuButtons count]];
    
    for(int index = 0; index < [_subMenuButtons count]; index++){
      subMenuButton = [_subMenuButtons objectAtIndex:index];
      testButtonStartRect[index] = subMenuButton.frame;
      subMenuButton.hidden = NO;
      
      if(!_isSubMenuExpanded){
        subMenuButton.transform = CGAffineTransformMakeRotation(M_PI);
        subMenuButton.center = centerPoint;
      }
    }
    if(_isSubMenuExpanded){
      for(int index = 0; index < [_subMenuButtons count]; index++){
        subMenuButton = [_subMenuButtons objectAtIndex:index];
        temporaryFrame = testButtonStartRect[index];
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                         animations:^(void){
                           subMenuButton.center = centerPoint;
                           subMenuButton.transform = CGAffineTransformMakeRotation(-M_PI);
                           _menuButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                           _menuButton.center = centerPoint;
                         }
                         completion:^(BOOL finished){
                           subMenuButton.frame = temporaryFrame;
                           subMenuButton.hidden = YES;
                           _isAnimating = NO;
                           _isSubMenuExpanded = NO;
                         }];
      }
    }
    else{
      for(int index = 0; index < [_subMenuButtons count]; index++){
        subMenuButton = [_subMenuButtons objectAtIndex:index];
        temporaryFrame = testButtonStartRect[index];
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                         animations:^(void){
                           subMenuButton.frame = temporaryFrame;
                           subMenuButton.transform = CGAffineTransformMakeRotation(0);
                           _menuButton.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
                           _menuButton.center = centerPoint;
                         }
                         completion:^(BOOL finished){
                           _isAnimating = NO;
                           _isSubMenuExpanded = YES;
                         }];
      }
    }
  }
}

@end

@implementation ViewController (Private)

- (void)sortButtons; {                                                        // Sort the buttons array.
  NSDictionary * dict = nil;                                                  // Dict assigns labels to buttons so we can sort them alphanumerically.
  NSMutableArray * sortArray = [NSMutableArray array];                        // The dictionaries are stored in an autoreleased array.
  for(UIButton * button in _subMenuButtons){                                  // For each button linked to _subMenuButtons.
    // Make a dictionary for each button.
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%d", button.tag], @"tag",
            button, @"button",
            nil];
    [sortArray addObject:dict];                                               // Add the dictionary to the sort array.
  }
  // Create a sort descriptor to look at the tags of the buttons and compare
  // them alphanumerically.
  NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"tag"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)];
  
  NSArray * descriptors = [NSArray arrayWithObjects:descriptor, nil];         // Descriptor tells the sort how to compare objects with key @"tag".
  NSArray * sortedButtons = [sortArray sortedArrayUsingDescriptors:descriptors];// Sort into a new array of dictionaries.
  
  NSMutableArray * newSortedButtons = [[NSMutableArray alloc] initWithCapacity:[_subMenuButtons count]];// Alloc the new sorted array of buttons.
  UIButton * button = nil;                                                    // Get a pointer to a UIButton.
  
  for(int i = 0; i < [_subMenuButtons count]; i++){                           // For each of the buttons,
    dict = [sortedButtons objectAtIndex:i];                                   // Grab the dictionary at index i.
    button = [dict objectForKey:@"button"];                                   // Grab the button in the dictionary.
    [newSortedButtons addObject:button];                                      // Just store the button component of dict.
    button.exclusiveTouch = YES;                                              // Set the button to have exclusive touch, so no Funny business!
  }
  _subMenuButtons = newSortedButtons;                                         // Set the _subMenuButtons array to the newSortedButtons array.
}

- (void)expandButtonAtIndex:(uint)aIndex; {
  if(aIndex >= [_subMenuButtons count]){
    return;
  }
  UIButton * subMenuButton = [_subMenuButtons objectAtIndex:aIndex];
  CGRect temporaryFrame = subMenuButton.frame;
  subMenuButton.center = _menuButtonCenter;
  subMenuButton.transform = CGAffineTransformMakeRotation(M_PI);
  subMenuButton.hidden = NO;
  float duration = (AnimationExpandDuration / ((float)[_subMenuButtons count]));
  
  [UIView animateWithDuration:(duration * 3.0f / 4.0f)
                        delay:0.0f
                      options:UIViewAnimationCurveEaseIn
                   animations:^(void){
                     subMenuButton.frame = temporaryFrame;
                     subMenuButton.transform = CGAffineTransformMakeRotation(0);
                   }
                   completion:^(BOOL finished){
                     [self expandButtonAtIndex:(aIndex + 1)];
                     
                     [UIView animateWithDuration:(duration / 2.0f)
                                           delay:0.0f
                                         options:UIViewAnimationCurveEaseOut
                                      animations:^(void){
                                        subMenuButton.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
                                      }
                                      completion:^(BOOL finished){
                                        [UIView animateWithDuration:(duration / 2.0f)
                                                              delay:0.0f
                                                            options:UIViewAnimationCurveEaseIn
                                                         animations:^(void){
                                                           subMenuButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                         }
                                                         completion:^(BOOL finished){
                                                           if(aIndex == ([_subMenuButtons count] - 1)){
                                                             _isAnimating = NO;
                                                             _isSubMenuExpanded = YES;
                                                           }
                                                         }];
                                      }];
                   }];
}

- (void)contractButtonAtIndex:(int)aIndex; {
  if(aIndex < 0){
    return;
  }
  UIButton * subMenuButton = [_subMenuButtons objectAtIndex:aIndex];
  CGRect temporaryFrame = subMenuButton.frame;
  float duration = (AnimationContractDuration / ((float)[_subMenuButtons count]));
  
  [UIView animateWithDuration:(duration / 2.0f)
                        delay:0.0f
                      options:UIViewAnimationCurveEaseIn
                   animations:^(void){
                     subMenuButton.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
                   }
                   completion:^(BOOL finished){
                     [UIView animateWithDuration:(duration / 2.0f)
                                           delay:0.0f
                                         options:UIViewAnimationCurveEaseOut
                                      animations:^(void){
                                        subMenuButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                      }
                                      completion:^(BOOL finished){
                                        [self contractButtonAtIndex:(aIndex - 1)];
                                        
                                        [UIView animateWithDuration:(duration * 3.0f / 4.0f)
                                                              delay:0.0f
                                                            options:UIViewAnimationCurveEaseIn
                                                         animations:^(void){
                                                           subMenuButton.transform = CGAffineTransformMakeRotation(M_PI);
                                                           subMenuButton.center = _menuButtonCenter;
                                                         }
                                                         completion:^(BOOL finished){
                                                           subMenuButton.frame = temporaryFrame;
                                                           subMenuButton.hidden = YES;
                                                           
                                                           if(aIndex == 0){
                                                             _isAnimating = NO;
                                                             _isSubMenuExpanded = NO;
                                                           }
                                                         }];
                                      }];
                   }];
}

@end