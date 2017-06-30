//
//  ViewController.m
//  FindEmail
//
//  Created by 吕 俊衡 on 2017/1/9.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MBProgressHUD+Extension.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextView *txtView;
    UITableView *emailTable;
    UILabel *lblPercent;
    NSArray *arrUrls;
    NSMutableArray *arrEmails;
    int totalUrls;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrUrls = [NSArray new];
    arrEmails = [NSMutableArray new];
    
    UIControl *contentView = [UIControl new];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(self.view);
        make.center.equalTo(self.view);
    }];
    
    txtView = [UITextView new];
    [txtView setBackgroundColor:UIColorFromRGB(0xf4f4f4)];
    [txtView setText:@"http://www.guruediting.com,http://www.experteditor.co.uk,http://www.proofright.co.uk,http://www.checkmyessay.net,http://www.precisionconsultingcompany.com,http://www.trueediting.com,http://www.editing-writing.com,http://www.dissertationhouse.co.uk,http://www.topcorrect.com,http://www.regentediting.co.za,http://www.theacademicpapers.co.uk,http://www.editex.com,http://www.abcproofreading.co.uk,http://www.uqu.com.au,http://www.truedissertation.com,http://www.allcorrect.org,http://www.uk-assignments.com,http://www.proofreadingservice247.co.uk,http://www.findaproofreader.com,http://www.prof-editing.com,http://www.proofreadbot.com"];
    [contentView addSubview:txtView];
    [txtView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(contentView).multipliedBy(1.0/2).offset(-30);
        make.top.equalTo(contentView).offset(60);
        make.left.equalTo(contentView).offset(20);
        make.bottom.equalTo(contentView).offset(-20);
    }];
    
    emailTable = [UITableView new];
    [emailTable setBackgroundColor:UIColorFromRGB(0xf4f4f4)];
    [emailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [emailTable setDelegate:self];
    [emailTable setDataSource:self];
    [contentView addSubview:emailTable];
    [emailTable mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(contentView).multipliedBy(1.0/2).offset(-30);
        make.top.equalTo(contentView).offset(60);
        make.right.equalTo(contentView).offset(-20);
        make.bottom.equalTo(contentView).offset(-20);
    }];
    
    UIButton *btnFind = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnFind setTitle:@"开始搜索" forState:UIControlStateNormal];
    [contentView addSubview:btnFind];
    [btnFind mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.top.equalTo(contentView).offset(10);
        make.left.equalTo(contentView).offset(10);
    }];

    lblPercent = [UILabel new];
    [contentView addSubview:lblPercent];
    [lblPercent mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(contentView);
        make.centerY.equalTo(btnFind);
    }];
    
    UIButton *btnPaste = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnPaste setTitle:@"复制" forState:UIControlStateNormal];
    [contentView addSubview:btnPaste];
    [btnPaste mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.top.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(10);
    }];
    
    
    [contentView addTarget:txtView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [btnFind addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
    [btnPaste addTarget:self action:@selector(btnPaste) forControlEvents:UIControlEventTouchUpInside];
}

-(void)find {
    [txtView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [txtView text];
    arrUrls = [urlString componentsSeparatedByString:@","];
    totalUrls = (int)[arrUrls count];
    NSMutableArray *arrUrlRemain = [NSMutableArray arrayWithArray:arrUrls];
    [self next:arrUrlRemain];
}

-(void)next:(NSMutableArray *)arrRemain {
    int count = (int)[arrRemain count];
    [lblPercent setText:[NSString stringWithFormat:@"还剩%d个url，共%d个",count,totalUrls]];
    if (count<=0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [emailTable reloadData];
        return;
    }
    NSString *url = arrRemain[0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString * appConnect = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url]
//                                                               encoding:NSUTF8StringEncoding
//                                                                  error:nil];
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                                             returningResponse:nil
                                                         error:nil];
        NSString * appConnect = [[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self findEmail:appConnect url:url];
            [arrRemain removeObjectAtIndex:0];
            [self next:arrRemain];
        });
    });
}

-(void)findEmail:(NSString *)string url:(NSString *)url {
    if (!string || [string isKindOfClass:[NSNull class]] || string.length == 0 || [string isEqualToString:@""]) {
        [MBProgressHUD showToast:[NSString stringWithFormat:@"%@不能打开",url]];
        NSMutableArray *arrEmailOfUrl = [NSMutableArray new];
        [arrEmails addObject:arrEmailOfUrl];
    }else{
        NSError *error;
        NSString *regulaStr = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        
        NSMutableArray *arrEmailOfUrl = [NSMutableArray new];
        for (NSTextCheckingResult *match in arrayOfAllMatches) {
            NSString* substringForMatch = [string substringWithRange:match.range];
            NSLog(@"%@",substringForMatch);
            if (![arrEmailOfUrl containsObject:substringForMatch]) {
                [arrEmailOfUrl addObject:substringForMatch];
            }
        }
        [arrEmails addObject:arrEmailOfUrl];
    }
}

-(void)btnPaste {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *emails = @"";
    for (NSArray *arr in arrEmails) {
        for (NSString *str in arr) {
            emails = [NSString stringWithFormat:@"%@,%@",emails,str];
        }
    }
    
    pasteboard.string = [emails substringFromIndex:1];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark tableView datasource&delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [arrUrls count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrEmails[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * showUserInfoCellIdentifier = @"EmailCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
    }
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:[UIView new]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    NSArray *arr = arrEmails[section];
    NSString *content = arr[row];
    [cell.textLabel setText:content];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [UIView new];
    [myView setBackgroundColor:UIColorFromRGB(0x999999)];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    titleLabel.text = arrUrls[section];
    [myView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(myView);
        make.center.equalTo(myView);
    }];
    return myView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}


@end
