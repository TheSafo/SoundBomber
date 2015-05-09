//
//  StoreManager.h
//  Impression
//
//  Created by Jason Fieldman on 4/15/14.
//  Copyright (c) 2014 Jason Fieldman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Singleton.h"


@interface SKProduct (printing)
-(NSString*) priceWithSymbol;
@end



@interface StoreManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, assign) BOOL       adsPurchased;
@property (nonatomic, strong) SKProduct *adsProduct;

//@property (nonatomic, assign) BOOL     customPurchased;
//@property (nonatomic, strong) SKProduct *customProduct;
//
//
//@property (nonatomic, strong) NSString* customPrice;
@property (nonatomic, strong) NSString* adsPrice;


SINGLETON_INTR(StoreManager);

-(void) updatePurchaseInfo;
-(void) restorePurchase;
-(void) purchaseAds;

//- (void) initiatePurchase;

@end
