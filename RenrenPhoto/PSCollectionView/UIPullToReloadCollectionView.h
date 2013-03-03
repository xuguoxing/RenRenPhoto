//
//  UIPullToReloadCollectionView.h
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-23.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "PSCollectionView.h"
#import "UIPullToReloadHeaderView.h"
#import "MessageInterceptor.h"
@interface UIPullToReloadCollectionView : PSCollectionView<UIScrollViewDelegate>
{
    BOOL checkForRefresh;
}

@property (nonatomic,strong) UIPullToReloadHeaderView *pullToReloadHeaderView;

-(void) pullDownToReloadActionFinished;
-(void) autoPullDownToRefresh;
@end
