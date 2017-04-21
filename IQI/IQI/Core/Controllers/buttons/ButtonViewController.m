//
//  ButtonViewController.m
//  IQI
//
//  Created by 王玉 on 2017/4/20.
//  Copyright © 2017年 orbyun. All rights reserved.
//

#import "ButtonViewController.h"
#import "DCPathButton.h"
#import "PicsLikeControl.h"

@interface ButtonViewController ()<DCPathButtonDelegate,PicsLikeControlDelegate>
@property (nonatomic,strong) UIViewController * btnView;
@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    DCPathButton *dcPathButton = [[DCPathButton alloc]
                                  initDCPathButtonWithSubButtons:6
                                  totalRadius:60
                                  centerRadius:15
                                  subRadius:15
                                  centerImage:@"custom_center"
                                  centerBackground:nil
                                  subImages:^(DCPathButton *dc){
                                      [dc subButtonImage:@"custom_1" withTag:0];
                                      [dc subButtonImage:@"custom_2" withTag:1];
                                      [dc subButtonImage:@"custom_3" withTag:2];
                                      [dc subButtonImage:@"custom_4" withTag:3];
                                      [dc subButtonImage:@"custom_5" withTag:4];
                                      [dc subButtonImage:@"custom_1" withTag:5];
                                  }
                                  subImageBackground:nil
                                  inLocationX:0 locationY:0 toParentView:self.view];
    dcPathButton.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)button_0_action{
    NSLog(@"Button Press Tag 0!!");
    _btnView = [[UIViewController alloc]init];
    UIImage *image0 = [UIImage imageNamed:@"main-camera-button"];
    UIImage *image1 = [UIImage imageNamed:@"main-library-button"];
    NSArray *images = @[image0, image1];
    PicsLikeControl *picControl = [[PicsLikeControl alloc] initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight/2, 44, 44) multiImages:images];
    picControl.delegate = self;
    [_btnView.view addSubview:picControl];
    [self presentViewController:_btnView animated:YES completion:nil];
    
}

- (void)button_1_action{
    NSLog(@"Button Press Tag 1!!");
}

- (void)button_2_action{
    NSLog(@"Button Press Tag 2!!");
}

- (void)button_3_action{
    NSLog(@"Button Press Tag 3!!");
}

- (void)button_4_action{
    NSLog(@"Button Press Tag 4!!");
}

- (void)button_5_action{
    NSLog(@"Button Press Tag 5!!");
}


- (void)controlTappedAtIndex:(int)index{
    if (index == 0) {
        [_btnView dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
