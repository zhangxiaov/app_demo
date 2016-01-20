//
//  ZImagePickerController.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/25.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "ZImagePickerController.h"
#import <Photos/Photos.h>

@interface ZGridImageViewController : UIViewController

@property (nonatomic, strong) NSMutableArray* images;

@end

@implementation ZGridImageViewController

//- (instancetype)initWithGroup:(ALAssetsGroup*)group
//{
//    self = [super init];
//    if (self) {
//        NSString *g=[NSString stringWithFormat:@"%@",group];
//        NSString *g1=[g substringFromIndex:16 ] ;
//        NSArray *arr=[[NSArray alloc] init];
//        arr=[g1 componentsSeparatedByString:@","];
//        NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
//        
//        self.title = g2;
//    }
//    
//    return self;
//}
//
//- (void)viewDidLoad {
//    
//}
//
//-(void)filterImageWithGroup:(ALAssetsGroup *)group {
//    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion =
//    ^(ALAsset *result,NSUInteger index, BOOL *stop)
//    {
//        if (result!=NULL)
//        {
//            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
//                [self.images addObject:result];
////                result.thumbnail                             ;//图片的缩略图小图
//            }
//        }
//        
//        
//    };
//    
//    [group enumerateAssetsUsingBlock:groupEnumerAtion];
//}
//
//- (NSMutableArray *)images {
//    if (_images == nil) {
//        _images = [@[] mutableCopy];
//    }
//    
//    return _images;
//}

@end

@interface ZImagePickerController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray* groupNames;
@property (nonatomic, strong) UITableView* groupTable;

@end

@implementation ZImagePickerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    [self.view addSubview:self.table];
    
    return self;
}

- (void)viewDidLoad {
    [self getData];
}

- (void)getData {
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    
    
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    
    // 在资源的集合中获取第一个集合，并获取其中的图片
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    PHAsset *asset = assetsFetchResults[0];
//    [imageManager requestImageForAsset:asset
//                            targetSize:{22,22}
//                           contentMode:PHImageContentModeAspectFill
//                               options:nil
//                         resultHandler:^(UIImage *result, NSDictionary *info) {
//                             
//                             // 得到一张 UIImage，展示到界面上
//                             
//                         }];
}



#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString* title = [NSString stringWithFormat:@"%@ (%@)", self.groupNames[indexPath.row][@"groupName"], ((NSNumber*)self.groupNames[indexPath.row][@"number"]).stringValue];
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    ZGridImageViewController* controller = [[ZGridImageViewController alloc] initWithGroup:self.groupNames[indexPath.row][@"group"]];
//    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark

- (NSMutableArray *)groupNames {
    if (_groupNames == nil) {
        _groupNames = [@[] mutableCopy];
    }
    
    return _groupNames;
}

- (UITableView *)table {
    if (_groupTable == nil) {
        _groupTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _groupTable.delegate = self;
        _groupTable.dataSource = self;
        _groupTable.rowHeight = 44;
    }
    
    return _groupTable;
}

@end


