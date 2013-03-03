//
//  UIPullToReloadTableView.m
//  NeteaseLottery
//
//  Created by xuguoxing on 12-6-8.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import "UIPullToReloadTableView.h"
@implementation UIPullToReloadTableView
{
    BOOL checkForRefresh;
}
@synthesize pullToReloadHeaderView;

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //self.delegate = self;
        //self.dataSource = self;
        
        delegate_interceptor = [[MessageInterceptor alloc]init];
        delegate_interceptor.middleMan = self;
        [super setDelegate:(id)delegate_interceptor];
        [super setDataSource:(id)delegate_interceptor];

        
        self.pullToReloadHeaderView = [[UIPullToReloadHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.bounds.size.height,
                                                                                                   self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:pullToReloadHeaderView];
    }
    return self;
}

-(id<UITableViewDelegate>)delegate
{
    return delegate_interceptor.receiver;
}

-(void)setDelegate:(id<UITableViewDelegate>)delegate
{
    [super setDelegate:nil];
    delegate_interceptor.receiver = delegate;
    [super setDelegate:(id)delegate_interceptor];
}



#pragma tableView Delegate
/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}*/


#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
	checkForRefresh = YES;  //  only check offset when dragging
} 

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
	
	if (checkForRefresh) {
		if (scrollView.contentOffset.y > -kPullDownToReloadToggleHeight && scrollView.contentOffset.y < 0.0f) {
			[pullToReloadHeaderView setStatus:kPullStatusPullDownToReload animated:YES];
		} else if (scrollView.contentOffset.y < -kPullDownToReloadToggleHeight) {
			[pullToReloadHeaderView setStatus:kPullStatusReleaseToReload animated:YES];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
	if ([pullToReloadHeaderView status]==kPullStatusReleaseToReload) {
		[pullToReloadHeaderView startReloading:self animated:YES];
        if ([self.delegate respondsToSelector:@selector(pullDownToReloadAction)]) {
            [self.delegate performSelector:@selector(pullDownToReloadAction)];
        }
	}
	checkForRefresh = NO;
}

-(void) autoPullDownToRefresh{
	[self scrollViewWillBeginDragging:self];
	[self setContentOffset:CGPointMake(0,-kPullDownToReloadToggleHeight-20) animated:NO];
	[self scrollViewDidScroll:self];
	[self scrollViewDidEndDragging:self willDecelerate:YES];
}


-(void) pullDownToReloadActionFinished{
    [self.pullToReloadHeaderView setLastUpdatedDate:[NSDate date]];
	[self.pullToReloadHeaderView finishReloading:self  animated:YES];
}
#pragma mark actions

/*-(void) pullDownToReloadAction {
	NSLog(@"TODO: Overload this");
}*/


@end
