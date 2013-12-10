//
//  PAPlaceApiManager.h
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/5.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PAPlaceApiDelegate <NSObject>

- (void)didReceivePredictions:(NSArray *)predictions;
- (void)didFailWithError:(NSError *)error;

@end


@interface PAPlaceApiManager : NSObject <NSURLConnectionDataDelegate>

@property id<PAPlaceApiDelegate> delegate;

- (PAPlaceApiManager *)initWithDelegate:(id<PAPlaceApiDelegate>)delegate;
- (void)predictionsWithInput:(NSString *)input;

@end