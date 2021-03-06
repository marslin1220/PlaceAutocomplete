//
//  PAPlaceApiManager.h
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/5.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@protocol PAPlaceApiDelegate <NSObject>

- (void)didReceivePredictions:(NSArray *)predictions;
- (void)didReceiveDetail:(NSDictionary *)placeDetail;
- (void)didReceiveSearchResult:(NSArray *)searchResult;
- (void)didFailWithError:(NSError *)error;

@end


@interface PAPlaceApiManager : NSObject <NSURLConnectionDataDelegate>

@property id<PAPlaceApiDelegate> delegate;

- (PAPlaceApiManager *)initWithDelegate:(id<PAPlaceApiDelegate>)delegate;
- (void)requestForPlaceAutoCompleteWithInput:(NSString *)input;
- (void)requestForPlaceNearby;
- (void)requestForPlaceWithInput:(NSString *)input;
- (void)resultWithReference:(NSString *)reference;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end