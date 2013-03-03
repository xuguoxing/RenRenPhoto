//
//  UIPullToReloadCollectionView.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-23.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "UIPullToReloadCollectionView.h"

@implementation UIPullToReloadCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pullToReloadHeaderView = [[UIPullToReloadHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.bounds.size.height,
                                                                                                  self.bounds.size.width,self.bounds.size.height)];
        [self addSubview:self.pullToReloadHeaderView];
        self.delegate = self;

    }
    return self;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([self.pullToReloadHeaderView status] == kPullStatusLoading) return;
	checkForRefresh = YES;  //  only check offset when dragging
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([self.pullToReloadHeaderView status] == kPullStatusLoading) return;
	
	if (checkForRefresh) {
		if (scrollView.contentOffset.y > -kPullDownToReloadToggleHeight && scrollView.contentOffset.y < 0.0f) {
			[self.pullToReloadHeaderView setStatus:kPullStatusPullDownToReload animated:YES];
		} else if (scrollView.contentOffset.y < -kPullDownToReloadToggleHeight) {
			[self.pullToReloadHeaderView setStatus:kPullStatusReleaseToReload animated:YES];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([self.pullToReloadHeaderView status] == kPullStatusLoading) return;
	if ([self.pullToReloadHeaderView status]==kPullStatusReleaseToReload) {
		[self.pullToReloadHeaderView startReloadingScrollView:self animated:YES];
        if ([self.collectionViewDelegate respondsToSelector:@selector(pullDownToReloadAction)]) {
            [self.collectionViewDelegate performSelector:@selector(pullDownToReloadAction)];
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
	[self.pullToReloadHeaderView finishReloadingScrollView:self  animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
