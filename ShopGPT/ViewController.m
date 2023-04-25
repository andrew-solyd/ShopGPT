//
//  ViewController.m
//  ShopGPT
//
//  Created by Andrew Yakovlev on 4/18/23.
//

#import "ViewController.h"
#import <BlinkEReceiptStatic/BRAccountLinkingManager.h>
#import <BlinkReceiptStatic/BlinkReceiptStatic.h>
#import <BlinkEReceiptStatic/BRAccountLinkingManager.h>

@interface ViewController ()

@property (strong, nonatomic) BRAccountLinkingManager *accountLinkingManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.accountLinkingManager = [[BRAccountLinkingManager alloc] init];
}

- (IBAction)linkToRetailer:(id)sender {
    
    self.status.text =  @"Linking..";
        
    BRAccountLinkingCredentials *creds = [BRAccountLinkingCredentials new];
    creds.username = @"yakovlev.andrei@gmail.com";
    creds.password = @"RD8hj5OFNYN^$=E";
    creds.retailer = BRAccountLinkingRetailerWegmans;
    [[BRAccountLinkingManager shared] linkAccountWithCredentials:creds];
    
    [[BRAccountLinkingManager shared] verifyAccountForRetailer:BRAccountLinkingRetailerWegmans withCompletion:^(BRAccountLinkingError error, UIViewController * _Nullable viewController, NSString * _Nonnull message) {
        if (error == BRAccountLinkingErrorNone) {
            self.orders.text = @"Ready to show last order here...";
            self.status.text =  @"Linked..";
            NSLog(@"Successfully linked account!");
        } else {
            self.orders.text = @"Failed to link to Wegmans...";
        }
    }];
    
}

- (IBAction)getOrders:(id)sender {
    
    self.status.text = @"Getting orders..";
    self.orders.text = @"Orders will show here...";
    
    [[BRAccountLinkingManager shared] grabNewOrdersWithCompletion:^(BRAccountLinkingRetailer retailer, BRScanResults * _Nullable results, NSInteger ordersRemainingInAccount, UIViewController * _Nullable verificationViewController, BRAccountLinkingError error, NSString * _Nonnull sessionId) {
        if (error == BRAccountLinkingErrorNone) {
                
            // Show count of orders currently saved
            NSArray<BRProduct *> *products = results.products;
            NSArray<BRProduct *> *filteredProducts = [products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"retailer == %@", [BRAccountLinkingCredentials nameForRetailer:BRAccountLinkingRetailerWegmans]]];
            NSUInteger count = filteredProducts.count;
            self.orders.text = [NSString stringWithFormat:@"%lu orders found", (unsigned long)count];
        
            
        } else {
            self.orders.text = @"Failed to get orders...";
        }
    }];
    
}

- (IBAction)showRetailers:(id)sender {
    
    
    NSArray<NSNumber *> *linkedRetailers = [self.accountLinkingManager getLinkedRetailers];
    NSMutableArray<NSDictionary *> *retailersArray = [[NSMutableArray alloc] init];
        
        for (NSNumber *retailer in linkedRetailers) {
            [retailersArray addObject:@{@"retailer": retailer}];
        }

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:retailersArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        self.orders.text = jsonString;
    
}

@end
