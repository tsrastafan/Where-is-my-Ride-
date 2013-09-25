//
//  TSSHCenterViewController.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 9/25/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSSHCenterViewControllerDelegate <NSObject>

- (void)movePanelToOriginalPosition;

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@end

@interface TSSHCenterViewController : UIViewController

@end
