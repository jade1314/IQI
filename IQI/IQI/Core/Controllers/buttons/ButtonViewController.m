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
#import "CEViewController.h"

#import "DKCircleButton.h"
#import "TJLBarButtonMenu.h"

@interface ButtonViewController ()<DCPathButtonDelegate,PicsLikeControlDelegate>
{
    BOOL buttonState;
    DKCircleButton * button1;
    DKCircleButton * button2;
}
@property (nonatomic,strong) UIViewController * btnView;
@property (nonatomic,strong) UIViewController * viewController;
@property (nonatomic,strong) UIViewController *colorView;

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
    CEViewController * btn = [[CEViewController alloc]init];
    [self presentViewController:btn animated:YES completion:nil];
}

- (void)button_2_action{
    NSLog(@"Button Press Tag 2!!");
    _viewController = [UIViewController new];
    
    _viewController.view.backgroundColor = [UIColor colorWithRed:0.29 green:0.59 blue:0.81 alpha:1];
    
    button1 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    
    button1.center = CGPointMake(kScreenWidth/2, kScreenHeight/3);
    button1.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [button1 setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [button1 setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
    [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
    
    [button1 addTarget:self action:@selector(tapOnButton) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewController.view addSubview:button1];
    
    button2 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    
    button2.center = CGPointMake(kScreenWidth/2, kScreenHeight * 0.6);
    button2.titleLabel.font = [UIFont systemFontOfSize:22];
    button2.animateTap = NO;
    
    [button2 setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [button2 setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [button2 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [button2 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
    [button2 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
    
    [button2 addTarget:self action:@selector(tapOnButton) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewController.view addSubview:button2];
    [self presentViewController:_viewController animated:YES completion:nil];
}

- (void)button_3_action{
    NSLog(@"Button Press Tag 3!!");
    _colorView = [[UIViewController alloc]init];
    _colorView.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(showRight:)];
    _colorView.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(showLeft:)];
    [self.navigationController pushViewController:_colorView animated:YES];
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

- (void)tapOnButton {
    if (buttonState) {
        [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
        [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
        [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
        
        [button2 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
        [button2 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
        [button2 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
        
    } else {
        [button1 setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
        [button1 setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateSelected];
        [button1 setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateHighlighted];
        
        [button2 setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
        [button2 setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateSelected];
        [button2 setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateHighlighted];
        [_viewController dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    buttonState = !buttonState;
}
- (void)showRight:(UIBarButtonItem *)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"Blue"],
                        [UIImage imageNamed:@"Green"]
                        ];
    TJLBarButtonMenu *barMenu = [[TJLBarButtonMenu alloc]initWithViewController:self
                                                                         images:images
                                                                   buttonTitles:@[@"Blue", @"Green"]
                                                                       position:TJLBarButtonMenuRightTop];
    
    [barMenu setButtonTappedBlock:^(TJLBarButtonMenu *buttonView, NSString *title) {
        NSLog(@"%@", title);
    }];
    [barMenu show];
    
    
}
- (void)showLeft:(UIBarButtonItem *)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"Blue"],
                        [UIImage imageNamed:@"Green"],
                        [UIImage imageNamed:@"Orange"]
                        ];
    TJLBarButtonMenu *barMenu = [[TJLBarButtonMenu alloc]initWithViewController:self
                                                                         images:images
                                                                   buttonTitles:@[@"Blue", @"Green", @"Orange"]
                                                                       position:TJLBarButtonMenuLeftTop];
    
    [barMenu setButtonTappedBlock:^(TJLBarButtonMenu *buttonView, NSString *title) {
        NSLog(@"%@", title);
    }];
    [barMenu show];
    [_colorView.navigationController popViewControllerAnimated:YES];
}

@end
