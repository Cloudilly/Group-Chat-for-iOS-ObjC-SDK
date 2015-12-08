//
//  ViewController.m
//  anonymous
//
//  Created by Zhongcai Ng on 28/10/15.
//  Copyright © 2015 Cloudilly Private Limited. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
@end

@implementation ViewController

-(id)init {
    self= [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        msgs= [NSMutableArray array];
        NSString *app= @"<INSERT YOUR APP NAME>";
        NSString *access= @"<INSERT YOUR ACCESS KEY>";
        self.cloudilly= [[Cloudilly alloc] initWithApp:app AndAccess:access WithCallback:^(void) {
            [self addMsg:@"CONNECTING..."];
            [self.cloudilly connect];
        }];
        [self.cloudilly addDelegate:self];
    }
    return self;
}

-(void)loadView {
    width= [[UIScreen mainScreen] bounds].size.width;
    height= [[UIScreen mainScreen] bounds].size.height;
    self.view= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
    self.view.backgroundColor= [UIColor whiteColor];
    
    UIView *status= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 20.0)];
    status.backgroundColor= [UIColor blackColor];
    [self.view addSubview:status];
    
    UIView *top= [[UIView alloc] initWithFrame:CGRectMake(0.0, 20.0, width, 50.0)];
    top.backgroundColor= [UIColor blackColor];
    [self.view addSubview:top];
    
    UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 26.0, width, 36.0)];
    title.font= [UIFont fontWithName:@"ChalkboardSE-Bold" size:22.0];
    title.backgroundColor= [UIColor clearColor];
    title.textAlignment= NSTextAlignmentCenter;
    title.textColor= [UIColor whiteColor];
    title.text= @"Cloudilly";
    [self.view addSubview:title];
    
    msgsTableView= [[UITableView alloc] initWithFrame:CGRectMake(0.0, 70.0, width, height- 120.0) style:UITableViewStylePlain];
    msgsTableView.backgroundColor= [UIColor whiteColor];
    msgsTableView.delegate= self;
    msgsTableView.dataSource= self;
    msgsTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:msgsTableView];
    
    bottom= [[UIView alloc] initWithFrame:CGRectMake(0.0, height- 50.0, width, 50.0)];
    bottom.userInteractionEnabled= YES;
    bottom.backgroundColor= [UIColor grayColor];
    [self.view addSubview:bottom];
    
    UIView *text= [[UIView alloc] initWithFrame:CGRectMake(5.0, 5.0, width- 70.0, 40.0)];
    text.backgroundColor= [UIColor whiteColor];
    [bottom addSubview:text];
    
    field= [[UITextField alloc] initWithFrame:CGRectMake(10.0, 0.0, width- 80.0, 40.0)];
    field.keyboardAppearance= UIKeyboardAppearanceDark;
    field.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    field.autocorrectionType= UITextAutocorrectionTypeYes;
    field.font= [UIFont systemFontOfSize:22.0];
    field.returnKeyType= UIReturnKeySend;
    field.delegate= self;
    [text addSubview:field];
    
    UIButton *sendBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn addTarget:self action:@selector(fireSend) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font= [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:22.0];
    sendBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentCenter;
    sendBtn.frame= CGRectMake(width- 60.0, 0.0, 60.0, 50.0);
    [bottom addSubview:sendBtn];
    [self.view addSubview:bottom];
}

-(void)fireSend {
    if(field.text.length== 0) { return; }
    NSMutableDictionary *payload= [[NSMutableDictionary alloc] init];
    [payload setObject:field.text forKey:@"msg"];
    [self.cloudilly postGroup:@"public" WithPayload:payload WithCallback:^(NSDictionary *dict) {
        if([[dict objectForKey:@"status"] isEqual: @"fail"]) { NSLog(@"%@", [dict objectForKey:@"msg"]); return; }
        NSLog(@"@@@@@@ POST");
        NSLog(@"%@", dict);
    }];
    field.text= @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(field.text.length== 0) { return NO; }
    NSMutableDictionary *payload= [[NSMutableDictionary alloc] init];
    [payload setObject:field.text forKey:@"msg"];
    [self.cloudilly postGroup:@"public" WithPayload:payload WithCallback:^(NSDictionary *dict) {
        if([[dict objectForKey:@"status"] isEqual: @"fail"]) { NSLog(@"%@", [dict objectForKey:@"msg"]); return; }
        NSLog(@"@@@@@@ POST");
        NSLog(@"%@", dict);
    }];
    field.text= @"";
    return NO;
}

-(CGFloat)returnMsgHeight:(NSString *)msg {
    NSDictionary *attributeNormal= [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:18.0] forKey:NSFontAttributeName];
    return [msg boundingRectWithSize:CGSizeMake(width- 20.0, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeNormal context:nil].size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *msg= [msgs objectAtIndex:indexPath.row];
    return indexPath.row== 0 ? [self returnMsgHeight:msg]+ 20.0 : [self returnMsgHeight:msg]+ 10.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return msgs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier= @"Cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell== nil) { cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; }
    cell.textLabel.text= [msgs objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines= 0;
    return cell;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame= [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardHeight= height- keyboardFrame.origin.y;
    double duration= [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        msgsTableView.frame= CGRectMake(0.0, 70.0, width, height- 70.0- 49.0- keyboardHeight);
        bottom.frame= CGRectMake(0.0, height- 50.0- keyboardHeight, width, 50.0);
        [self scrollToBottom];
    }];
}

-(void)scrollToBottom {
    if(msgsTableView.contentSize.height< msgsTableView.frame.size.height) { return; }
    double delayInSeconds= 0.1; dispatch_time_t popTime= dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        CGPoint offset= CGPointMake(0, msgsTableView.contentSize.height- msgsTableView.frame.size.height);
        [msgsTableView setContentOffset:offset animated:YES];
    });
}

-(void)addMsg:(NSString *)msg {
    [msgs addObject:msg];
    [msgsTableView reloadData];
    [self scrollToBottom];
}

//
// CLOUDILLY DELEGATES
//

-(void)socketConnected:(NSDictionary *)dict {
    if([[dict objectForKey:@"status"] isEqual: @"fail"]) { NSLog(@"%@", [dict objectForKey:@"msg"]); return; }
    NSLog(@"@@@@@@ CONNECTED");
    NSLog(@"%@", dict);
    
    [self addMsg:[NSString stringWithFormat:@"CONNECTED AS %@", [[dict objectForKey:@"device"] uppercaseString]]];
    [self.cloudilly joinGroup:@"public" WithCallback:^(NSDictionary *dict) {
        if([[dict objectForKey:@"status"] isEqual: @"fail"]) { NSLog(@"%@", [dict objectForKey:@"msg"]); return; }
        NSLog(@"@@@@@@ JOIN");
        NSLog(@"%@", dict);
        [self addMsg:[NSString stringWithFormat:@"DEVICES PRESENT IN PUBILC: %@", [dict objectForKey:@"total_devices"]]];
    }];
}

-(void)socketDisconnected {
    NSLog(@"@@@@@@ DISCONNECTED");
    [msgs removeAllObjects];
    [self addMsg:@"DISCONNECTED"];
}

-(void)socketReceivedDevice:(NSDictionary *)dict {
    NSLog(@"@@@@@@ RECEIVED DEVICE");
    NSLog(@"%@", dict);
    NSString *other= [[dict objectForKey:@"device"] uppercaseString];
    NSString *action= [[dict objectForKey:@"timestamp"] isEqualToNumber:[NSNumber numberWithInt:0]] ? @"JOINED" : @"LEFT";
    [self addMsg:[NSString stringWithFormat:@"%@ %@ PUBLIC", other, action]];
}

-(void)socketReceivedPost:(NSDictionary *)dict {
    NSLog(@"@@@@@@ RECEIVED POST");
    NSLog(@"%@", dict);
    NSString *other= [[dict objectForKey:@"device"] uppercaseString];
    [self addMsg:[NSString stringWithFormat:@"%@: %@", other, [[dict objectForKey:@"payload"] objectForKey:@"msg"]]];
}

-(UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
-(void)viewDidLoad { [super viewDidLoad]; }
-(void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end