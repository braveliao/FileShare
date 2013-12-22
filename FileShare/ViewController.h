//
//  ViewController.h
//  FileShare
//
//  Created by liaoyong on 12/13/13.
//  Copyright (c) 2013 redcdn.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
}

@property (nonatomic, strong) IBOutlet UITextField *userNameTextfield;
@property (nonatomic, strong) IBOutlet UITextField *passWordTextField;
@property (nonatomic, strong) IBOutlet UITextField *ipTextField;

- (IBAction)loginBtn:(id)sender;

@end
