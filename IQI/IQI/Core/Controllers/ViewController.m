//
//  ViewController.m
//  IQI
//
//  Created by 王玉 on 2017/2/8.
//  Copyright © 2017年 orbyun. All rights reserved.
//

#import "ViewController.h"
#import "IQIAMapViewController.h"

#import "HangQingCollectionCell.h"
#import "HangQingCollectionTwoCell.h"
#import "HangQingCollectionThreeCell.h"
#import "HangQingCollectionReusableView.h"
#import "MainViewController.h"


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * IQIHome;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WHITE;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _IQIHome = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight) collectionViewLayout:layout];
    _IQIHome.backgroundColor = COLOR_YELLOW;
    _IQIHome.delegate = self;
    _IQIHome.dataSource = self;
    _IQIHome.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    [_IQIHome registerClass:[HangQingCollectionCell class] forCellWithReuseIdentifier:@"cellone"];
    [_IQIHome registerClass:[HangQingCollectionTwoCell class] forCellWithReuseIdentifier:@"celltwo"];
    [_IQIHome registerClass:[HangQingCollectionThreeCell class] forCellWithReuseIdentifier:@"cellthree"];
    [_IQIHome registerClass:[HangQingCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellreuse"];
    [self.view addSubview:_IQIHome];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 7;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HangQingCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellone" forIndexPath:indexPath];
        cell.name.text = [NSString stringWithFormat:@"%ld++++%ld",indexPath.section,indexPath.row];
        cell.backgroundColor = random_color;
        return cell;
    }else if (indexPath.section == 1){
        HangQingCollectionTwoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"celltwo" forIndexPath:indexPath];
        
        cell.backgroundColor = random_color;
        cell.name.text = [NSString stringWithFormat:@"%ld++++%ld",indexPath.section,indexPath.row];
        return cell;
    }else{
        HangQingCollectionThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellthree" forIndexPath:indexPath];
        cell.backgroundColor = random_color;
        cell.name.text = [NSString stringWithFormat:@"%ld++++%ld",indexPath.section,indexPath.row];
        return cell;
    }
//    return [UICollectionViewCell new];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HangQingCollectionReusableView *viewHd = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cellreuse" forIndexPath:indexPath];
    ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetailPage:)];
    [viewHd addGestureRecognizer:tap];//@"领涨板块",
    
    return viewHd;
}

- (void)jumpDetailPage:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    self.view.userInteractionEnabled = NO;
    NSLog(@"%@",tap);
}

#pragma mark - <XWDragCellCollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {MainViewController *aMapView = [[MainViewController alloc]init];
            [self.navigationController pushViewController:aMapView animated:YES];}
            break;
        case 1:
        {IQIAMapViewController *aMapView = [[IQIAMapViewController alloc]init];
            [self.navigationController pushViewController:aMapView animated:YES];}
            break;
        
            
        default:
            break;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth/3 - KSINGLELINE_WIDTH, 100);
    }else if (indexPath.section == 1){
        return CGSizeMake(kScreenWidth/3 - KSINGLELINE_WIDTH, 80);
    }else{
        return CGSizeMake(kScreenWidth, 55);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1 || section == 0) {
        return KSINGLELINE_WIDTH;
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1 || section == 0) {
        return KSINGLELINE_WIDTH;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(kScreenWidth, 30);
}
#pragma mark - TreasureLayout DataSource

//- (CGSize)collectionViewContentSize:(GHTreasureLayout *)layout
//{
//    return CGSizeMake(0, 100 + 30 + 80 * 2 +( 55 * 5 + 30) * 5);
//}
//
//- (CGRect)treasureLayout:(GHTreasureLayout *)layout eachFrameForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    /***
//     此layout的规则适用度有限，并不能解决所有的layout情况，仅供demo参考
//     ***/
//    if (indexPath.section == 0) {
//        return CGRectMake(kScreenWidth/3 *(indexPath.item%3), 0, kScreenWidth/3 - KSINGLELINE_WIDTH, KCollHeight - KSINGLELINE_WIDTH);
//        
//    }else if (indexPath.section == 1){
//        return CGRectMake( kScreenWidth/3 *(indexPath.item%3),KCollHeight + 30 + KCollNextHeight * (indexPath.item/3),  kScreenWidth/3 - KSINGLELINE_WIDTH, KCollNextHeight - KSINGLELINE_WIDTH);
//    }else{
//        return CGRectMake(0, KCollHeight + 30 * 2 + KCollNextHeight * 2 + 55 * indexPath.item +( 55 * 5 + 30) * (indexPath.section - 2), kScreenWidth, 55);
//    }
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
