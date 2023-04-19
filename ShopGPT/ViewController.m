//
//  ViewController.m
//  ShopGPT
//
//  Created by Andrew Yakovlev on 4/18/23.
//

#import "ViewController.h"
#import <BlinkEReceiptStatic/BRAccountLinkingManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)showSomething:(id)sender {
    
    self.customMessage = @"Linking account...";
    
    
    BRAccountLinkingCredentials *creds = [BRAccountLinkingCredentials new];
    creds.username = @"yakovlev.andrei@gmail.com";
    creds.password = @"RD8hj5OFNYN^$=E";
    creds.retailer = BRAccountLinkingRetailerWegmans;
    [[BRAccountLinkingManager shared] linkAccountWithCredentials:creds];
    
    [[BRAccountLinkingManager shared] verifyAccountForRetailer:BRAccountLinkingRetailerWegmans withCompletion:^(BRAccountLinkingError error, UIViewController * _Nullable viewController, NSString * _Nonnull message) {
        if (error == BRAccountLinkingErrorNone) {
            NSLog(@"Successfully linked account!");
            self.customMessage = @"Account linked!";
        } else {
            self.customMessage = @"Error linking.";
        }
    }];
    
    
    // Update the label's text with the custom message
    self.myGreet.text = self.customMessage;
    
}
@end
