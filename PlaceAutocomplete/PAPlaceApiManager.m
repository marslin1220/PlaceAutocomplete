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
#define PLACE_NEARBY @"https://maps.googleapis.com/maps/api/place/nearbysearch/json"
#define PLACE_SEARCH @"https://maps.googleapis.com/maps/api/place/textsearch/json"
#define MAX_ALLOWED_RADIUS_METERS 50000
#define RADIUS_METERS 50

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

- (void)requestForPlaceNearby
{
    if (![CLLocationManager locationServicesEnabled] || !self.locationManager.location) {
        return;
    }
    
    CLLocationCoordinate2D currentCoordinate = self.locationManager.location.coordinate;
    
    NSString *queryString = [NSString stringWithFormat:@"%@?key=%@&location=%f,%f&radius=%d&sensor=true",
                             PLACE_NEARBY,
                             API_KEY,
                             currentCoordinate.latitude,
                             currentCoordinate.longitude,
                             RADIUS_METERS];
    
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

- (void)requestForPlaceWithInput:(NSString *)input
{
    NSString *queryString = [NSString stringWithFormat:@"%@?key=%@&sensor=true&query=%@",
                             PLACE_SEARCH,
                             API_KEY,
                             input];
    
    if ([CLLocationManager locationServicesEnabled] && self.locationManager.location) {
        CLLocationCoordinate2D currentCoordinate = self.locationManager.location.coordinate;
        
        queryString = [queryString stringByAppendingFormat:@"&location=%f,%f&radius=%d",
                       currentCoordinate.latitude,
                       currentCoordinate.longitude,
                       RADIUS_METERS];
    }
    
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
    NSLog(@"> %s connection: %@", __PRETTY_FUNCTION__, connection);
    NSString *urlString = [connection.originalRequest.URL absoluteString];
    
    id jsonObject = [PAPlaceJsonParser jsonWithResponseData:self.responseData];
    
    if ([urlString rangeOfString:PLACE_AUTOCOMPLETE].location != NSNotFound) {
        NSArray *predictions = [jsonObject objectForKey:@"predictions"];
        if (predictions && [self.delegate respondsToSelector:@selector(didReceivePredictions:)]) {
            [self.delegate didReceivePredictions:predictions];
        }
    }
    else if ([urlString rangeOfString:PLACE_NEARBY].location != NSNotFound
             || [urlString rangeOfString:PLACE_SEARCH].location != NSNotFound) {
        
        NSArray *searchResults = [jsonObject objectForKey:@"results"];
        if (searchResults && [self.delegate respondsToSelector:@selector(didReceiveSearchResult:)]) {
            [self.delegate didReceiveSearchResult:searchResults];
        }
    }
    else if ([urlString rangeOfString:PLACE_DETAILS].location != NSNotFound) {
        NSDictionary *placeDetail = [jsonObject objectForKey:@"result"];
        if (placeDetail && [self.delegate respondsToSelector:@selector(didReceiveDetail:)]) {
            [self.delegate didReceiveDetail:placeDetail];
        }
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
