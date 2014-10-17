//
//  A0SelectExampleViewController.m
//  A0SimpleKeychain
//
//  Created by Hernan Zalazar on 10/17/14.
//  Copyright (c) 2014 Hernan Zalazar. All rights reserved.
//

#import "A0SelectExampleViewController.h"
#import "A0ViewController.h"

@interface A0SelectExampleViewController ()

@end

@implementation A0SelectExampleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TouchID"]) {
        A0ViewController *controller = segue.destinationViewController;
        controller.useTouchID = YES;
    }
}

@end
