//
//  IQIAMapViewController.m
//  IQI
//
//  Created by 王玉 on 2017/2/10.
//  Copyright © 2017年 orbyun. All rights reserved.
//

#import "IQIAMapViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "HttpRequest.h"
#import "AnnotationModelRootClass.h"
#import "CustomAnnotationView.h"

#import "MANaviRoute.h"
static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;
#define kCalloutViewMargin          -8

#define annURL @"http://api1.chediandian.com/GetMapData.ashx"

@interface IQIAMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>//

@property (nonatomic,strong) AMapSearchAPI * search;
@property (nonatomic,strong) AMapTransitRouteSearchRequest * navi;
@property (nonatomic,strong) NSMutableArray  * annsArr;
@property (nonatomic,strong) NSMutableArray * annsArray;
@property (nonatomic,strong) MAPinAnnotationView * currentSelectPin;
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateC;

@property (nonatomic,strong) AMapRidingRouteSearchRequest *naviRide;
//@property (nonatomic,strong) MANaviRoute *route;
@property (nonatomic, strong) AMapRoute *route;

@property (nonatomic,strong) MANaviRoute *naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic,strong) UIButton * gpsButton;

@end

@implementation IQIAMapViewController

- (NSMutableArray *)annsArr{
    if (!_annsArr) {
        _annsArr = [[NSMutableArray alloc]init];
    }
    return _annsArr;
}

- (NSMutableArray *)annsArray{
    if (!_annsArray) {
        _annsArray = [[NSMutableArray alloc]init];
    }
    return _annsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsCompass = YES;
    _mapView.showsScale = YES;
    _mapView.delegate = self;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnClicked:)];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithTitle:@"画点" style:UIBarButtonItemStylePlain target:self action:@selector(drawPoint:)];
    UIBarButtonItem *rightItem3 = [[UIBarButtonItem alloc]initWithTitle:@"去店里" style:UIBarButtonItemStylePlain target:self action:@selector(goToStore:)];
    self.navigationItem.rightBarButtonItems = @[rightItem,rightItem2,rightItem3];
    

    //search对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    _naviRide = [[AMapRidingRouteSearchRequest alloc] init];
    
    self.gpsButton = [self makeGPSButtonView];
    self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 20);
    [self.view addSubview:self.gpsButton];
    self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self addDefaultAnnotations];
}

- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
    }
}

- (void)drawPoint:(UIBarButtonItem *)sender{
    [self requestData];
}

- (void)goToStore:(UIBarButtonItem *)sender{
    UIViewController *view = [[UIViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}




- (void)barBtnClicked:(UIBarButtonItem *)sender{

    [self.search AMapRidingRouteSearch:_naviRide];
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self updateCourseUI];
    [self updateDetailUI];
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}
    //解析response获取路径信息，具体解析见 Demo
#pragma mark - Utility
/* 更新"上一个", "下一个"按钮状态. */
- (void)updateCourseUI
{
//    /* 上一个. */
//    self.previousItem.enabled = (self.currentCourse > 0);
//    
//    /* 下一个. */
//    self.nextItem.enabled = (self.currentCourse < self.totalCourse - 1);
}



/* 更新"详情"按钮状态. */
- (void)updateDetailUI
{
    self.navigationItem.rightBarButtonItem.enabled = self.route != nil;
}

- (void)updateTotal
{
    self.totalCourse = self.route.paths.count;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeRiding;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

- (void)requestData{
//    point1=116.221050,39.866443&point2=116.331050,40.001847&centerPoint=116.282420,39.940480&servicetype=0&serviceDetail=0&isfreeclean=1
    CLLocation *loc =  _mapView.userLocation.location;
    if (!loc) {
        return;
    }
    double latitudeMax =  loc.coordinate.latitude + 0.05;
    double latitudeMin = loc.coordinate.latitude - 0.05;
    double longitudeMax = loc.coordinate.longitude + 0.05;
    double longitudeMin = loc.coordinate.longitude - 0.05;
    NSString *str1 = [NSString stringWithFormat:@"%f,%f",longitudeMax,latitudeMax];
    NSString *str2 = [NSString stringWithFormat:@"%f,%f",longitudeMin,latitudeMin];

    NSString *strCenter = [NSString stringWithFormat:@"%f,%f",loc.coordinate.longitude,loc.coordinate.latitude];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:str2 forKey:@"point1"];
    [dict setValue:str1 forKey:@"point2"];
    [dict setValue:strCenter forKey:@"centerPoint"];
    [dict setValue:@"0" forKey:@"servicetype"];
    [dict setValue:@"0" forKey:@"serviceDetail"];
    [dict setValue:@"1" forKey:@"isfreeclean"];
    
    [HttpRequest showProgressHUD];
    [[HttpRequest getInstance] postWithURLString:annURL headers:nil orbYunType:0 parameters:dict success:^(id responseObject, NSURLSessionTask *task) {
        
        NSArray *annArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i < annArray.count; i ++) {
            AnnotationModelRootClass *model = [[AnnotationModelRootClass alloc]initWithDictionary:annArray[i]];
            [self.annsArr addObject:model];
        }
        
        
        [self createPoints];
        
    } failure:^(NSError *error, NSURLSessionTask *task) {
        
    }];
}

- (void)createPoints{
    
    for (int i = 0; i < _annsArr.count; i ++) {
        
        AnnotationModelRootClass *model = _annsArr[i];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        NSArray *point = [model.entpoint componentsSeparatedByString:@","];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([point[1] doubleValue], [point[0] doubleValue]);
        
        pointAnnotation.title = model.entname;
        pointAnnotation.subtitle = model.entaddress;
        [self.annsArray addObject:pointAnnotation];
    }
    
    [self.mapView addAnnotations:self.annsArray];
}





- (void)naviGO:(UIButton *)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple;
//        return annotationView;
//    }
//
//    
//    
//    return nil;
//}

/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        

        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                case MANaviAnnotationTypeRiding:
                    poiAnnotationView.image = [UIImage imageNamed:@"ride"];
                    break;
                    
                default:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
            }
        }else if ([annotation isKindOfClass:[MAPointAnnotation class]]){
            static NSString *reuseIndetifier = @"annotationReuseIndetifier";
            CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:reuseIndetifier];
            }
            annotationView.image = [UIImage imageNamed:@"car"];
            annotationView.name = annotation.title;
            annotationView.detailName = annotation.subtitle;
//            annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//            annotationView.draggable = YES;        //设置标注可以拖动，默认为NO

            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView.centerOffset = CGPointMake(0, -18);
            return annotationView;
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    
//    if ([overlay isKindOfClass:[LineDashPolyline class]])
//    {
//        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
//        polylineRenderer.lineWidth   = 8;
//        polylineRenderer.lineDashPattern = @[@10, @15];
//        polylineRenderer.strokeColor = [UIColor redColor];
        
//        return polylineRenderer;
//    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}


- (void)searchBegin{
    
}


//当检索失败时，会进入 didFailWithError 回调函数，通过该回调函数获取产生的失败的原因。
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/*!
 @brief 当取消选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    
}
/**
 * @brief 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param view 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
    [self clear];
    _currentSelectPin = [[MAPinAnnotationView alloc]init];
    MAPointAnnotation *point = view.annotation;
//    NSLog(@"%@++++=====%f", point, point.coordinate.longitude);
     _coordinateC =  point.coordinate;
//    NSLog(@"++++=====%f",  _coordinateC.longitude);
    
    /* 出发点. */
    CLLocation *loc =  _mapView.userLocation.location;
    
    _naviRide.origin = [AMapGeoPoint locationWithLatitude:loc.coordinate.latitude
                                                longitude:loc.coordinate.longitude];
    self.startCoordinate = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude);
    /* 目的地. */
    _naviRide.destination = [AMapGeoPoint locationWithLatitude:_coordinateC.latitude
                                                     longitude:_coordinateC.longitude];
    self.destinationCoordinate = CLLocationCoordinate2DMake(_coordinateC.latitude, _coordinateC.longitude);
    
    [self.search AMapRidingRouteSearch:_naviRide];
    
    
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}





@end
