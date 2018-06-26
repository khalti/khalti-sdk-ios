//
//  ViewController.m
//  Khalti-Pay
//
//  Created by Rajendra Karki on 2/27/18.
//  Copyright © 2018 Rajendra Karki. All rights reserved.
//

#import "ViewController.h"
#import "Khalti-Swift.h"

@interface ViewController () <KhaltiPayDelegate>
    
    @property (nonatomic, strong) Config *config;

    @end

@implementation ViewController
    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
- (IBAction)pay:(UIButton *)sender {
    
    id objects[] = { @false, @true, @42, @12.23 };
    id keys[] = { @"no", @"yes", @"int", @"float" };
    NSUInteger count = sizeof(objects) / sizeof(id);
    NSDictionary *extra = [NSDictionary dictionaryWithObjects:objects
                                                      forKeys:keys
                                                        count:count];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extra
                                                       options:(NSJSONWritingOptions)    (NSJSONWritingPrettyPrinted)
                                                         error:&error];
    
    
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        jsonString = @"{}";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    id extraObjects[] = { @"haha", jsonString };
    id extraKeys[] = { @"merchant_name", @"merchant_extra" };
    NSUInteger extraCount = sizeof(extraObjects) / sizeof(id);
    NSDictionary *additionalData = [NSDictionary dictionaryWithObjects:extraObjects
                                                      forKeys:extraKeys
                                                        count:extraCount];
    
    NSString * key = @"test_public_key_dc74e0fd57cb46cd93832aee0a507256";
    NSInteger *amount = 1000;
    Config *config = [[Config alloc] initWithPublicKey:key amount:amount productId:@"123123" productName:@"Dragon_boss" productUrl:@"as" additionalData:additionalData cardPayment: false];
    
    
    [Khalti presentWithCaller:self with:config delegate:self];
}

- (void)onCheckOutSuccessWithData:(NSDictionary<NSString *,id> *)data {
    NSLog(@"Oh there is Succes");
}

- (void)onCheckOutErrorWithAction:(NSString *)action message:(NSString *)message {
    NSLog(@"Oh there is error");
}

    @end



