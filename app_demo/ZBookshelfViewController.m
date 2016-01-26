//
//  ZBookshelfViewController.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZBookshelfViewController.h"
#import "ZBookshelfCell.h"
#import "ZBookshelfSupplementaryView.h"
#import "AppConfig.h"
#import "ZDBManager.h"

@interface ZBookshelfViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation ZBookshelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书架";
    
    [self.view addSubview:self.bookCollectionView];
    [self prepareData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addBook)];
}

- (void)prepareData {
    self.bookArray = [[ZDBManager manager] getBookshelf];
}


#pragma mark Event

- (void)addBook {
    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZBookshelfCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZBookshelfCell reuseIdentifier] forIndexPath:indexPath];
    [cell fillData:self.bookArray[indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ZBookshelfSupplementaryView* headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[ZBookshelfSupplementaryView reuseIdentifier] forIndexPath:indexPath];
    
    return headerView;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark setter

- (UICollectionView *)bookCollectionView {
    if (_bookCollectionView == nil) {
        
        CGFloat w = SCREEN_WIDTH - 10;
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 2;
        layout.itemSize = CGSizeMake(w/3, w/3);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(44, 44);
        
        _bookCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _bookCollectionView.backgroundColor = [UIColor whiteColor];
        _bookCollectionView.delegate = self;
        _bookCollectionView.dataSource = self;
        
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 0);
        _bookCollectionView.contentInset = inset;
        
        [_bookCollectionView registerClass:[ZBookshelfCell class] forCellWithReuseIdentifier:[ZBookshelfCell reuseIdentifier]];
        [_bookCollectionView registerClass:[ZBookshelfSupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[ZBookshelfSupplementaryView reuseIdentifier]];
    }
    
    return _bookCollectionView;
}

@end
