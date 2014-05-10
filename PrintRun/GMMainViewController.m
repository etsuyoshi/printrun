//
//  GMMainViewController.m
//  PrintRun
//
//  Created by EndoTsuyoshi on 2014/05/10.
//  Copyright (c) 2014年 tsuyoshi. All rights reserved.
//

#import "GMMainViewController.h"

/*
 物体を上に引っ張って
 
 */

@interface GMMainViewController ()

@end

@implementation GMMainViewController

UIView *testView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"self=%@", self);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"start view did load");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    testView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 150, 250)];
    testView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:testView];
    
    
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(drag:)];
    [testView addGestureRecognizer:panGest];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//http://ringsbell.blog117.fc2.com/blog-entry-714.html
-(void)drag:(UIPanGestureRecognizer *)sender{
//    UIView *targetView = sender.view;
//    
//    
//    CGPoint p = [sender translationInView:targetView];//dragした後の(targetViewからの相対)位置
//    CGPoint movedPoint = CGPointMake(targetView.center.x + p.x,
//                                     targetView.center.y + p.y);//dragした後の絶対位置
//    targetView.center = movedPoint;//dragした後の絶対位置にtargetViewを移す
//    [sender setTranslation:CGPointZero inView:targetView];//targetViewの中心(メモリ)を現在位置にリセット
    
    //縦方向のみ移動
    UIView *targetView = sender.view;
    CGPoint p = [sender translationInView:targetView];//dragした後の(targetViewからの相対)位置
    CGPoint movedPoint = CGPointMake(targetView.center.x + p.x,
                                     targetView.center.y + p.y);//dragした後の絶対位置
    targetView.center = movedPoint;//dragした後の絶対位置にtargetViewを移す
    [sender setTranslation:CGPointZero inView:targetView];//targetViewの中心(メモリ)を現在位置にリセット

    
}

@end
