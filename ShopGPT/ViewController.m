//
//  ViewController.m
//  ShopGPT
//
//  Created by Andrew Yakovlev on 4/18/23.
//

#import "ViewController.h"
#import <BlinkEReceiptStatic/BRAccountLinkingManager.h>
#import <BlinkReceiptStatic/BlinkReceiptStatic.h>

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
    
    [[BRAccountLinkingManager shared] resetHistoryForRetailer:(BRAccountLinkingRetailerWegmans)];
    
    [[BRAccountLinkingManager shared] grabNewOrdersForRetailer:BRAccountLinkingRetailerWegmans withCompletion:^(BRAccountLinkingRetailer retailer, BRScanResults * _Nullable results, NSInteger ordersRemainingInAccount, UIViewController * _Nullable verificationViewController, BRAccountLinkingError error, NSString * _Nonnull sessionId) {
        if (error == BRAccountLinkingErrorNone) {
            
            self.orders.text = @" ";
            
            BRStringValue *receiptDateValue = results.receiptDate;
            NSString *receiptDateString = receiptDateValue.value;
            
            for (BRProduct *product in results.products) {
                NSString *productName = product.productName;
                NSString *productPrice = [NSString stringWithFormat:@"%.2f", product.unitPrice.value];
                NSString *productInfo = [NSString stringWithFormat:@"%@ $%@", productName, productPrice];
                // NSLog(productInfo);
                // [productsList addObject:productInfo];
                self.orders.text = [self.orders.text stringByAppendingString:productInfo];
                self.orders.text = [self.orders.text stringByAppendingFormat:@"\n"];
            }
            // NSString *productsString = [productsList componentsJoinedByString:@"\n"];
            // self.orders.text = productsString;
            // NSLog(productsString);
            
            self.status.text = [NSString stringWithFormat:@"Receipt date: %@", receiptDateString];
        }
    }];
    
}

- (IBAction)showRetailers:(id)sender {
    
    
    NSArray<NSNumber *> *linkedRetailers = [self.accountLinkingManager getLinkedRetailers];
    
    // Convert linkedRetailers to string
    NSMutableString *retailersString = [[NSMutableString alloc] init];
    
    for (NSNumber *retailer in linkedRetailers) {
        if (retailersString.length > 0) {
            [retailersString appendString:@", "];
        }
        [retailersString appendString:[NSString stringWithFormat:@"%@", retailer]];
    }
    
    // Output to self.orders.text
    self.orders.text = retailersString;
        
    
}

@end
