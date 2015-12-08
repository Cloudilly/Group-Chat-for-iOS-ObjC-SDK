//
//  ViewController.h
//  anonymous
//
//  Created by Zhongcai Ng on 28/10/15.
//  Copyright © 2015 Cloudilly Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cloudilly.h"

@class Cloudilly;

@interface ViewController: UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CloudillyDelegate> {
    CGFloat width;
    CGFloat height;
    UITableView *msgsTableView;
    NSMutableArray *msgs;
    UIView *bottom;
    UITextField *field;
}

@property (strong, nonatomic) Cloudilly *cloudilly;

@end