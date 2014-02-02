//
//  PAPlaceApiManager.m
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/5.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import "PAPlaceApiManager.h"
#import "PAPlaceJsonParser.h"
#import "PAPlaceApiKey.h"

#define PLACE_AUTOCOMPLETE @"https://maps.googleapis.com/maps/api/place/autocomplete/json"
#define PLACE_DETAILS @"https://maps.googleapis.com/maps/api/place/details/json"

@interface PAPlaceApiManager() <CLLocationManagerDelegate>

@property NSMutableData *responseData;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation PAPlaceApiManager

- (PAPlaceApiManager *)initWithDelegate:(id<PAPlaceApiDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.responseData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)predictionsWithInput:(NSString *)input
{
    [self requestForPlaceAutoCompleteWithInput:input];
}

- (void)resultWithReference:(NSString *)reference
{
    [self requestForPlaceDetailWithReference:reference];
}

- (void)requestForPlaceAutoCompleteWithInput:(NSString *)input
{
    NSString *queryString = [NSString stringWithFormat:@"%@?input=%@&sensor=true&key=%@", PLACE_AUTOCOMPLETE, input, API_KEY];
    queryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"> %s queryString: %@", __PRETTY_FUNCTION__, queryString);
    NSURL *placeQueryUrl = [NSURL URLWithString:queryString];
    NSURLRequest *request = [NSURLRequest requestWithURL:placeQueryUrl];
    NSURLConnection *connnection = [NSURLConnection connectionWithRequest:request
                                                                 delegate:self];
    
    if (!connnection) {
        NSLog(@"Can not create connection!");
    }
}

- (void)requestForPlaceDetailWithReference:(NSString *)reference
{
    NSString *queryString = [NSString stringWithFormat:@"%@?reference=%@&sensor=true&key=%@", PLACE_DETAILS, reference, API_KEY];
    queryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"> %s queryString: %@", __PRETTY_FUNCTION__, queryString);
    NSURL *placeQueryUrl = [NSURL URLWithString:queryString];
    NSURLRequest *request = [NSURLRequest requestWithURL:placeQueryUrl];
    NSURLConnection *connnection = [NSURLConnection connectionWithRequest:request
                                                                 delegate:self];
    
    if (!connnection) {
        NSLog(@"Can not create connection!");
    }
}

#pragma mark Implement NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"> %s", __PRETTY_FUNCTION__);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"> %s data: %@", __PRETTY_FUNCTION__, [[NSString alloc] initWithData:data
                                                                       encoding:NSUTF8StringEncoding]);
    
    if (data) {
        [self.responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"> %s", __PRETTY_FUNCTION__);
    
    id jsonObject = [PAPlaceJsonParser jsonWithResponseData:self.responseData];
    
    NSArray *predictions = [jsonObject objectForKey:@"predictions"];
    NSDictionary *result = [jsonObject objectForKey:@"result"];
    
    if (predictions && [self.delegate respondsToSelector:@selector(didReceivePredictions:)]) {
        [self.delegate didReceivePredictions:predictions];
    }
    
    if (result && [self.delegate respondsToSelector:@selector(didReceiveResult:)]) {
        [self.delegate didReceiveResult:result];
    }
    
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"> %s error: %@", __PRETTY_FUNCTION__, error);
    
    [self.delegate didFailWithError:error];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
}

#pragma mark - CLLocationManager Operation

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5;
    }
    
    return _locationManager;
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

@end
