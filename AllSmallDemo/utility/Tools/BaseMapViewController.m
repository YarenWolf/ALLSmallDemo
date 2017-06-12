//
////
////  GuangzhaoViewController.m
////  GuangFuBao
////  Created by 薛超 on 16/7/26.
////  Copyright © 2016年 55like. All rights reserved.
//#import "BaseMapViewController.h"
//#import "BMapKit.h"
//#import <CoreLocation/CoreLocation.h>
//#pragma mark 自定义气泡框
//@interface HMPointAnnoation : BMKPointAnnotation{
//    NSUInteger _tag;
//}
//@property NSUInteger tag;
//@end
//@implementation HMPointAnnoation
//@synthesize tag = _tag;
//@end
//@interface PointCell : UIView
//@property (strong, nonatomic) UILabel *city;
//@property (strong, nonatomic) UILabel *corr;
//@property (strong, nonatomic) UILabel *cita;
//@property (strong, nonatomic) UILabel *avTime;
//@property (nonatomic,strong)UIImageView *icon;
//@end
//@implementation PointCell
//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initUI];
//    }
//    return self;
//}
//- (void)initUI{
//    _city = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180, 20)];
//    _corr= [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 180, 20)];
//    _cita= [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 180, 20)];
//    _avTime= [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 180, 15)];
//    _city.font = _corr.font = _cita.font = _avTime.font = Font(12);
//    [self addSubviews:_city,_cita,_corr,_avTime,nil];
//    self.backgroundColor = RGBCOLOR(250, 250, 250);
//}
//@end
//@interface BaseMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UISearchBarDelegate>{
//    BMKMapView *_mapview;
//    BMKLocationService *_locService;
//    UIButton *selectMap;
//    CLGeocoder *_geocoder;
//    NSArray *resultArray;
//    UISearchBar *searchBar;
//}
//@property(nonatomic,strong)  CLLocationManager *locationManager;
//@end
//@implementation BaseMapViewController
//#pragma mark BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
//-(void)viewWillAppear:(BOOL)animated {
//    [_mapview viewWillAppear];
//    _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _locService.delegate = self;
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [_mapview viewWillDisappear];
//    [_locService stopUserLocationService];
//    _mapview.showsUserLocation = NO;
//    _mapview.delegate = nil; // 不用时，置nil
//    _locService.delegate = nil;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(70, TopHeight, APPW-100, 30)];
//    searchBar.placeholder = @"Search";
//    searchBar.barTintColor = [UIColor whiteColor];
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//    tap.numberOfTapsRequired = tap.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:tap];
//    
//    _geocoder=[[CLGeocoder alloc]init];
//    _mapview=[[BMKMapView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, APPH-64 )];
//    _mapview.scrollEnabled = YES;
//    _mapview.mapType = BMKMapTypeStandard;
//    _mapview.delegate=self;
//    [self.view addSubview:_mapview];
//    
//    selectMap=[[UIButton alloc]initWithFrame:CGRectMake(APPW-60, 80, 50, 30)];
//    [selectMap setTitle:@"标准" forState:UIControlStateNormal];
//    [selectMap setTitle:@"卫星" forState:UIControlStateSelected];
//    selectMap.backgroundColor = RGBACOLOR(10, 10, 10, 0.5);
//    [selectMap addTarget:self action:@selector(changeMap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:selectMap];
//    
//    //适配ios7
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
//        self.navigationController.navigationBar.translucent = NO;
//    }
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate=self;
//    [_locService startUserLocationService];
//    
//    _mapview.showsUserLocation = NO;//先关闭显示的定位图层
//    _mapview.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
//    _mapview.showsUserLocation = YES;//显示定位图层
//    
//    
//    [self addAnnotations];
//}
//#pragma mark Action
//-(void)myLocationClicked{
//    _locService.delegate=self;
//    [_locService startUserLocationService];
//    _mapview.showsUserLocation = NO;//先关闭显示的定位图层
//    _mapview.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
//    _mapview.showsUserLocation = YES;//显示定位图层
//    
//    CLLocationCoordinate2D coor;
//    coor.latitude = [[[Utility Share] userlatitude] doubleValue];//纬度
//    coor.longitude = [[[Utility Share] userlongitude] doubleValue];//经度
//    BMKCoordinateSpan span = {0.01,0.01};
//    BMKCoordinateRegion region = {coor,span};
//    [_mapview setRegion:region];
//}
//- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
//    CGPoint p = [sender locationInView:_mapview];
//    CLLocationCoordinate2D coord = [_mapview convertPoint:p toCoordinateFromView:_mapview];
//    HMPointAnnoation *ann = [[HMPointAnnoation alloc]init];
//    ann.coordinate=coord;
//    [_mapview addAnnotation:ann];
//    [_mapview selectAnnotation:ann animated:YES];
//}
//
//-(void)changeMap:(UIButton*)sender{
//    if(sender.selected)_mapview.mapType = BMKMapTypeStandard;
//    else _mapview.mapType = BMKMapTypeSatellite;
//    sender.selected = !sender.selected;
//}
//-(void)addAnnotations{
//    resultArray = @[
//                    @[@"39.92998356493645",@"116.3956367734679707",@"北京市",@"北京市",@"Φ+4",@"5.00h?"],
//                    @[@"22.806489937268527",@"108.2972329270525307",@"广西壮族自治区",@"南宁市",@"Φ+5",@"3.54h"],
//                    @[@"25.049150236168376",@"102.7145965574223507",@"云南省",@"昆明市",@"Φ-8",@"4.26h"],
//                    @[@"29.662553295957913",@"91.11188496716765",@"西藏自治区",@"拉萨市",@"Φ-8",@"6.70h"]];
//    for(int a = 0;a<resultArray.count;a++){
//        //创建大头针对象
//        HMPointAnnoation* annotation = [[HMPointAnnoation alloc]init];
//        annotation.coordinate= CLLocationCoordinate2DMake([resultArray[a][0] doubleValue], [resultArray[a][1] doubleValue]);
//        [_mapview addAnnotation:annotation];
//        if([resultArray[a][2] isEqualToString:@"北京市"]){
//            BMKCoordinateSpan span=BMKCoordinateSpanMake(8, 8);
//            BMKCoordinateRegion region=BMKCoordinateRegionMake(annotation.coordinate,span);
//            [_mapview setRegion:region];
//        }
//    }
//}
//
//#pragma mark - MKAnnotationView delegate
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView  viewForAnnotation:(id <BMKAnnotation>)annotation{
//    BMKPinAnnotationView *annoationView = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
//    if ([annotation isKindOfClass:[HMPointAnnoation class]]){
//        annoationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnorV"] ;
//        annoationView.canShowCallout = YES;
//        ((BMKPinAnnotationView*)annoationView).animatesDrop = YES;// 设置该标注点动画显示
//        annoationView.image = [UIImage imageNamed:@"location_mylocation"];
//        annoationView.annotation = annotation;
//        PointCell *popView = [[PointCell alloc]initWithFrame:CGRectMake(0, 0, 130, 90)];
//        CLLocation *location=[[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
//        [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//            CLPlacemark *placemark=[placemarks firstObject];
//            for(int a=0;a<resultArray.count;a++){
//                NSString *s ;
//                if(placemark.name.length>5)s= [placemark.name substringWithRange:NSMakeRange(2, 2)];
//                NSString *t = [resultArray[a][2] substringWithRange:NSMakeRange(0, 2)];
//                if([s isEqualToString:t]){
//                    popView.city.text = [NSString stringWithFormat:@"%@%@", resultArray[a][2],resultArray[a][3]];
//                    popView.corr.text =[NSString stringWithFormat:@"经纬度:%0.2f , %0.2f",annotation.coordinate.latitude,annotation.coordinate.longitude];
//                    popView.cita.text =[NSString stringWithFormat:@"最佳倾角:%@", resultArray[a][4]];
//                    popView.avTime.text = [NSString stringWithFormat:@"平均日照时间:%@",resultArray[a][5]];
//                }
//            }
//        }];
//        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
//        pView.frame = CGRectMake(0, 0, 100, 80);
//        ((BMKPinAnnotationView*)annoationView).paopaoView = pView;
//        return annoationView;
//    }
//    return nil;
//}
//- (void)willStartLocatingUser{
//    NSLog(@"开始定位");
//}
//
////用户方向更新后，会调用此函数
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
//    [_mapview updateLocationData:userLocation];
//}
//
////用户位置更新后，会调用此函数
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//    [_mapview updateLocationData:userLocation];
//    [[Utility Share]setUserlatitude:[NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude]];
//    [[Utility Share]setUserlongitude:[NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude]];
//    [_geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark=[placemarks firstObject];
//        for(int b=0;b<resultArray.count;b++){
//            if([resultArray[b][3] isEqualToString:placemark.locality]){
//                HMPointAnnoation* annotation = [[HMPointAnnoation alloc]init];
//                CLLocationCoordinate2D coor;
//                coor.latitude = [resultArray[b][0] doubleValue];
//                coor.longitude = [resultArray[b][1] doubleValue];
//                annotation.coordinate=coor;
//                //添加
//                BMKCoordinateSpan span=BMKCoordinateSpanMake(8, 8);
//                BMKCoordinateRegion region=BMKCoordinateRegionMake(annotation.coordinate,span);
//                [_mapview setRegion:region];
//                [_mapview addAnnotation:annotation];
//                [_mapview selectAnnotation:annotation animated:YES];
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setValue:resultArray[b][3] forKey:@"usercity"];
//                [defaults setValue:resultArray[b][5] forKey:@"userhour"];
//                [defaults synchronize];
//            }
//        }
//    }];
//    [_locService stopUserLocationService];
//}
//
//- (void)didStopLocatingUser{
//    NSLog(@"停止定位");
//}
//#pragma mark searchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [_geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark=[placemarks firstObject];
//        HMPointAnnoation *ann = [[HMPointAnnoation alloc]init];
//        ann.coordinate=placemark.location.coordinate;
//        BMKCoordinateSpan span=BMKCoordinateSpanMake(8, 8);
//        BMKCoordinateRegion region=BMKCoordinateRegionMake(ann.coordinate,span);
//        [_mapview setRegion:region];
//        [_mapview addAnnotation:ann];
//        [_mapview selectAnnotation:ann animated:YES];
//    }];
//}
//@end
//
