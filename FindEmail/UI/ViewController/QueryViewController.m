//
//  QueryViewController.m
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "QueryViewController.h"
#import "QueryView.h"
#import "InputViewController.h"
#import "QueryViewModel.h"

@interface QueryViewController ()<UIPopoverPresentationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)QueryView *queryView;
@property(nonatomic, strong)QueryViewModel *queryViewModel;
@property(nonatomic, strong)NSString *queryURLString;
@property(nonatomic, strong)NSMutableArray *queryURLArray;
@property(nonatomic, strong)NSMutableArray<URLEmail *> *queryResults;
@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)makeUI {
    _queryView = [QueryView new];
    [self.view addSubview:_queryView];
    [_queryView mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
}

-(void)listening {
    [_queryView.queryButton addTarget:self action:@selector(inputQueryUrls:) forControlEvents:UIControlEventTouchUpInside];
    [_queryView.segmentedControl addTarget:_queryView.tableView action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [_queryView.exportButton addTarget:self action:@selector(copyAllItems) forControlEvents:UIControlEventTouchUpInside];
    [_queryView.tableView setDelegate:self];
    [_queryView.tableView setDataSource:self];
}

-(void)inputQueryUrls:(UIButton *)sender {
    InputViewController *inputViewController = [InputViewController new];
    inputViewController.modalPresentationStyle = UIModalPresentationPopover;
    inputViewController.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    inputViewController.popoverPresentationController.sourceView = sender;
    inputViewController.popoverPresentationController.sourceRect = sender.bounds;
    inputViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    CGSize size = self.view.frame.size;
    inputViewController.preferredContentSize = size;
    inputViewController.popoverPresentationController.delegate = self;
    [inputViewController setInputBlock:^(NSString *urls){
        [self reloadEmailTable:urls];
    }];
//    inputViewController.defaultURL = _queryURLString;
    inputViewController.defaultURL = @"http://www.cyzone.cn/about/about.html,http://corp.hexun.com/default/index.html,http://www.tuniu.com/corp/aboutus.shtml,https://www.jd.com/intro/about.aspx,http://www.chinaemail.com.cn/page/content/1/,http://www.sina.com.cn/contactus.html,http://cd.haomaku.com/xh/?adid=6&lanmu=0,https://zhidao.baidu.com/question/4861730.html";
//    inputViewController.defaultURL = @"http://www.guruediting.com,http://www.experteditor.co.uk,http://www.proofright.co.uk,http://www.checkmyessay.net,http://www.precisionconsultingcompany.com,http://www.trueediting.com,http://www.editing-writing.com,http://www.dissertationhouse.co.uk,http://www.topcorrect.com,http://www.regentediting.co.za,http://www.theacademicpapers.co.uk,http://www.editex.com,http://www.abcproofreading.co.uk,http://www.uqu.com.au,http://www.truedissertation.com,http://www.allcorrect.org,http://www.uk-assignments.com,http://www.proofreadingservice247.co.uk,http://www.findaproofreader.com,http://www.prof-editing.com,http://www.proofreadbot.com";
    [self presentViewController:inputViewController animated:YES completion:nil];
}

-(void)clearResult {
    _queryResults = nil;
    _queryURLString = nil;
    _queryURLArray = nil;
    [_queryView.tableView reloadData];
    [_queryView.progressView setProgress:0 animated:YES];
    [_queryView.statusLabel setText:@"点击“+”输入网址"];
    [_queryView.exportButton setEnabled:NO];
}

-(void)reloadEmailTable:(NSString *)urls {
    [self clearResult];
    if ([urls length]==0) {
        return;
    }
    _queryResults = [NSMutableArray new];
    _queryURLString = urls;
    _queryURLArray = [NSMutableArray arrayWithArray:[urls componentsSeparatedByString:@","]];
    [_queryView.statusLabel setText:@"开始查询"];
    [MBProgressHUD showHUDAddedTo:_queryView animated:YES];
    [self queryNext];
}

-(void)queryNext {
    NSInteger totalCount = [_queryURLArray count];
    NSInteger currentCount = [_queryResults count];
    [_queryView.progressView setProgress:(currentCount+0.0)/totalCount animated:YES];
    if (currentCount == totalCount) {
        [_queryView.statusLabel setText:@"完成(长按导出单条/单个网页的结果，右上导出全部)"];
        [MBProgressHUD hideHUDForView:_queryView animated:YES];
        [_queryView.exportButton setEnabled:YES];
        return;
    }
    
    NSString *url = _queryURLArray[currentCount];
    [_queryView.statusLabel setText:[NSString stringWithFormat:@"正在查询：%@",url]];
    [self.queryViewModel queryFromURLString:url completion:^(URLEmail *urlEmail){
        [self addQueryResult:urlEmail];
    }];
}

-(void)addQueryResult:(URLEmail *)urlEmails {
    [_queryResults addObject:urlEmails];
    NSInteger count = [_queryResults count];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:count-1];
    [_queryView.tableView beginUpdates];
    [_queryView.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [_queryView.tableView endUpdates];
    if ([urlEmails.emails count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[urlEmails.emails count]-1 inSection:count-1];
        [_queryView.tableView scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionBottom
                                            animated:YES];
    }
    [self queryNext];
}

-(QueryViewModel *)queryViewModel {
    if (!_queryViewModel) {
        _queryViewModel = [QueryViewModel new];
    }
    return _queryViewModel;
}

#pragma mark - popoverPresentationController delegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return NO;
}

#pragma mark - tableViewDelegate &tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    URLEmail *urlEmail = _queryResults[section];
    if (_queryView.segmentedControl.selectedSegmentIndex == 0) {
        return [urlEmail.emails count];
    }
    return [urlEmail.phones count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_queryResults) {
        _queryResults = [NSMutableArray new];
    }
    return [_queryResults count];
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
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:0.5]];
    [cell setSelectedBackgroundView:view];
    [cell.textLabel setFont:[UIFont systemFontOfSize:kFontSizeSmall]];
    [cell.textLabel setTextColor:WKT_ORANGE_COLOR];
    URLEmail *urlEmail = _queryResults[section];
    if (_queryView.segmentedControl.selectedSegmentIndex == 0) {
        [cell.textLabel setText:urlEmail.emails[row]];
    }else{
        [cell.textLabel setText:urlEmail.phones[row]];
    }
    [self addCopyItem:cell.textLabel];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* myView = [UIView new];
    [myView rounded:YES radius:11];
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = section;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont systemFontOfSize:kFontSizeMedium]];
    [myView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(myView);
        make.center.equalTo(myView);
    }];
    [self addCopyItems:titleLabel];
    URLEmail *urlEmail = _queryResults[section];
    switch (urlEmail.state) {
        case QueryStateLoadFail: {
            [myView setBackgroundColor:WKT_RED_COLOR];
            titleLabel.text = [NSString stringWithFormat:@"该网页加载失败：%@",urlEmail.urlString];
        }
            break;
        case QueryStateEncodeFail: {
            [myView setBackgroundColor:WKT_GREEN_COLOR];
            titleLabel.text = [NSString stringWithFormat:@"该网页编码失败：%@",urlEmail.urlString];
        }
            break;
        default:{
            [myView setBackgroundColor:WKT_ORANGE_COLOR];
            titleLabel.text = urlEmail.urlString;
            if ([_queryView.segmentedControl selectedSegmentIndex]==0) {
                if ([[urlEmail emails] count] == 0) {
                    [myView setBackgroundColor:WKT_GRAY_COLOR];
                    titleLabel.text = [NSString stringWithFormat:@"该网页无邮箱：%@",urlEmail.urlString];
                }
            }else {
                if ([[urlEmail phones] count] == 0) {
                    [myView setBackgroundColor:WKT_GRAY_COLOR];
                    titleLabel.text = [NSString stringWithFormat:@"该网页无电话：%@",urlEmail.urlString];
                }
            }
        }
            break;
    }
    return myView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - copy
-(void)addCopyItem:(UILabel *)label{
    label.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyItem:)];
    [label addGestureRecognizer:touch];
}

-(void)copyItem:(UIGestureRecognizer*) recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan){
        UILabel *label = (UILabel *)[recognizer view];
        [self share:[label text]];
    }
}

-(void)addCopyItems:(UILabel *)label{
    label.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyItems:)];
    [label addGestureRecognizer:touch];
}

-(void)copyItems:(UIGestureRecognizer*) recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan){
        UILabel *label = (UILabel *)[recognizer view];
        NSInteger index = label.tag;
        URLEmail *urlEmail = _queryResults[index];
        if ([urlEmail.emails count]==0) {
            [MBProgressHUD showToast:@"该网页没有找到邮箱"];
            return;
        }
        NSString *emails = [NSString stringWithFormat:@"%@：",urlEmail.urlString];
        for (NSString *email in urlEmail.emails) {
            emails = [NSString stringWithFormat:@"%@\n%@",emails,email];
        }
        [self share:emails];
    }
}

-(void)copyAllItems {
    NSString *emails = @"";
    for (URLEmail *urlEmail in _queryResults) {
        if ([urlEmail.emails count] == 0) {
            continue;
        }
        if ([emails length]==0) {
            emails = urlEmail.urlString;
        }else {
            emails = [NSString stringWithFormat:@"%@\n\n%@",emails,urlEmail.urlString];
        }
        for (NSString *email in urlEmail.emails) {
            emails = [NSString stringWithFormat:@"%@\n%@",emails,email];
        }
    }
    if ([emails length]==0) {
        [MBProgressHUD showToast:@"没有可导出的邮箱"];
        return;
    }
    [self share:emails];
}

-(void)share:(NSString *)content {
    NSArray *activityItems = @[content];
    // 服务类型控制器
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    activityViewController.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    activityViewController.popoverPresentationController.sourceView = _queryView.exportButton;
    activityViewController.popoverPresentationController.sourceRect = _queryView.exportButton.bounds;
    activityViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    CGSize size = self.view.frame.size;
    activityViewController.preferredContentSize = size;
    [self presentViewController:activityViewController animated:YES completion:nil];
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            [MBProgressHUD showToast:@"好了。只是我在想每次都弹出来选似乎有点麻烦，要不要直接复制了，自己爱贴哪贴哪" duration:5];
        }
    }];
}

@end
