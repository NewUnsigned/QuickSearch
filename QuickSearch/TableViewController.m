//
//  TableViewController.m
//  QuickSearch
//
//  Created by 融通汇信 on 15/8/31.
//  Copyright (c) 2015年 融通汇信. All rights reserved.
//

#import "TableViewController.h"
#import "RTHXQuestionWebVC.h"
#import "IMQuickSearch.h"
#import "QuestionModel.h"

@interface TableViewController () <UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchBar     *searchBar;
@property (strong, nonatomic) UIBarButtonItem * searchButton;
@property (strong, nonatomic) UIBarButtonItem * backButton;
@property (copy,   nonatomic) NSString        *searchString;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快速搜索";
    [self configSearchBar];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    [self loadQuestionFromService];
}

- (void)loadQuestionFromService
{
    for (int i = 0; i < 100; i++) {
        QuestionModel *model = [[QuestionModel alloc]init];
        model.title = [NSString stringWithFormat:@"快速搜索标题%d",i];
        model.qa_url = @"http://www.baidu.com";
        model.qa_id = i;
        [self.questionArr addObject:model];
    }

    [self setUpQuickSearch];
    self.FilteredResults = [self.QuickSearch filteredObjectsWithValue:nil];
    [self filterResults];
}

#pragma mark - Set Up the Quick Search
- (void)setUpQuickSearch {
    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:self.questionArr keys:@[@"title"]];
    self.QuickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter]];
}

#pragma mark - Filter the Quick Search
- (void)filterResults {
    // Asynchronously && BENCHMARK TEST
    [self.QuickSearch asynchronouslyFilterObjectsWithValue:self.searchString completion:^(NSArray *filteredResults) {
        [self updateTableViewWithNewResults:filteredResults];
    }];
}

- (void)updateTableViewWithNewResults:(NSArray *)results {
    self.FilteredResults = [results sortedArrayUsingSelector:@selector(compareModel:)];
    [self.tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.FilteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    QuestionModel *contentObject = self.FilteredResults[indexPath.row];
    cell.textLabel.text = contentObject.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionModel *model = self.FilteredResults[indexPath.row];
    RTHXQuestionWebVC *question = [[RTHXQuestionWebVC alloc]init];
    question.urlString = model.qa_url;
    question.title = model.title;
    __weak typeof(self)weakSelf = self;
    question.refreshBlock = ^{
        [weakSelf searchBar:nil textDidChange:nil];
    };
    [self searchBarCancelButtonClicked:nil];
    [self.navigationController pushViewController:question animated:YES];
}

- (void)configSearchBar
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 28, 22);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(jumpToSearch) forControlEvents:UIControlEventTouchUpInside];
    _searchButton= [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = _searchButton;
}

- (void)jumpToSearch
{
    self.navigationItem.rightBarButtonItem = nil;
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.center = CGPointMake(self.view.frame.size.width/2, 84);
    _searchBar.frame = CGRectMake(10, 20,self.view.frame.size.width-20, 0);
    [_searchBar setContentMode:UIViewContentModeBottomLeft];
    _searchBar.delegate = self;
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    _searchBar.showsCancelButton =YES;
    _searchBar.tag = 1000;
    
    [self.navigationController.navigationBar addSubview:_searchBar];
    _searchBar.placeholder = @"关键字搜索";
    [_searchBar becomeFirstResponder];
}

#pragma -mark searchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = _searchButton;
    [self searchBar:nil textDidChange:nil];
    [_searchBar resignFirstResponder];
    [_searchBar removeFromSuperview];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchString = searchText;
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UITextField *tf;
    for (UIView *view in [[_searchBar.subviews objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            tf=(UITextField *)view;
        }
    }
    [_searchBar setShowsCancelButton:YES animated:YES];
    _searchBar.showsCancelButton=YES;
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
            UIButton *button=(UIButton*)subView;
            button.titleLabel.textColor=[UIColor whiteColor];
        }
    }
    UIButton *cancelButton;
    UIView *topView = _searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        [cancelButton setTitle:@"       " forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.textColor=[UIColor whiteColor];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:20];
        [cancelButton removeFromSuperview];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(5, -5,40,40)];
        lable.textAlignment=NSTextAlignmentLeft;
        lable.text=@"取消";
        lable.textColor=[UIColor whiteColor];
        [cancelButton addSubview:lable];
        lable.font = [UIFont fontWithName:@"Heiti SC" size:16];
        [cancelButton addSubview:lable];
    }
}

#pragma mark - lazy loading

- (NSMutableArray *)questionArr
{
    if (!_questionArr) {
        _questionArr = [NSMutableArray array];
    }
    return _questionArr;
}

@end
