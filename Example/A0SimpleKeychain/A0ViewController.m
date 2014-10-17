//  A0ViewController.m
//
// Copyright (c) 2014 Auth0 (http://auth0.com)
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

#import "A0ViewController.h"
#import <SimpleKeychain/A0SimpleKeychain.h>

@interface A0ViewController ()
@property (strong, nonatomic) A0SimpleKeychain *keychain;
@property (strong, nonatomic) NSString *key;
@end

@implementation A0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keychain = [A0SimpleKeychain keychain];
    if (self.useTouchID) {
        self.keychain.useAccessControl = YES;
        self.keychain.defaultAccesiblity = A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly;
        self.key = @"auth0-keychain-sample-touchid";
    } else {
        self.key = @"auth0-keychain-sample";
    }
}

- (void)save:(id)sender {
    NSString *value = self.valueField.text;
    if (value) {
        if (self.useTouchID) {
            [self.keychain setString:value forKey:self.key promptMessage:@"Wan't to save the key using touch id?"];
        } else {
            [self.keychain setString:value forKey:self.key];
        }
        self.messageLabel.text = [NSString stringWithFormat:@"Saved value '%@' in the Keychain", value];
    } else {
        self.messageLabel.text = @"Please enter a value to save in the Keychain";
    }
}

- (void)load:(id)sender {
    NSString *value;
    if (self.useTouchID) {
        value = [self.keychain stringForKey:self.key promptMessage:@"Do you want to access the key?"];
    } else {
        value = [self.keychain stringForKey:self.key];
    }
    if (value) {
        self.messageLabel.text = [NSString stringWithFormat:@"Obtained value '%@' from the Keychain", value];
    } else {
        self.messageLabel.text = @"No value found in the keychain";
    }
    self.valueField.text = value;
}

- (void)remove:(id)sender {
    [self.keychain deleteEntryForKey:self.key];
    self.valueField.text = nil;
    self.messageLabel.text = @"Entry deleted from Keychain";
}

@end
