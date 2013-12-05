//
//  PAPlaceTableViewDelegate.h
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/5.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAPlaceTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

- (PAPlaceTableViewDelegate *)initWithPlaceTextField:(UITextField *)textField
                                        andTableView:(UITableView *)tableView;

@end
