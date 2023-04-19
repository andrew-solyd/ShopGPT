//
//  ViewController.h
//  ShopGPT
//
//  Created by Andrew Yakovlev on 4/18/23.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *meButton;
- (IBAction)showSomething:(id)sender;

@property (copy, nonatomic) NSString *customMessage;
@property (weak, nonatomic) IBOutlet UILabel *myGreet;

@end

