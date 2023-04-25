//
//  ViewController.h
//  ShopGPT
//
//  Created by Andrew Yakovlev on 4/18/23.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *linktoRetailerButton;
- (IBAction)linkToRetailer:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *getOrdersButton;
- (IBAction)getOrders:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *showRetailersButton;
- (IBAction)showRetailers:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *orders;


@end

