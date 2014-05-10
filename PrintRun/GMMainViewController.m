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

UIView *view1;
UIView *view2;
UIView *originalView;
double speed;


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
    
    
    originalView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money_roll.png"]];
    originalView.frame = CGRectMake(100, 100, 150, 250);
    [self.view addSubview:originalView];
    
    
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 150, 250)];
    view1.backgroundColor = [UIColor grayColor];
    view1.tag = 1;
    [self.view addSubview:view1];
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 150, 250)];
    view2.backgroundColor = [UIColor redColor];
    view2.tag = 2;
    [self.view addSubview:view2];
    
    
    
    UIPanGestureRecognizer *panGest1 = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(drag:)];
    panGest1.delegate = self;
    [view1 addGestureRecognizer:panGest1];
    UIPanGestureRecognizer *panGest2 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(drag:)];
    panGest2.delegate = self;
    [view2 addGestureRecognizer:panGest2];
    
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
    
    //縦方向のみ移動
    UIView *targetView = sender.view;
    CGPoint p = [sender translationInView:targetView];//dragした後の(targetViewからの相対)位置
    NSLog(@"移動距離py1=%f", p.y);//移動距離
    CGPoint movedPoint = CGPointMake(targetView.center.x,
                                     targetView.center.y + p.y);//dragした後の絶対位置
    targetView.center = movedPoint;//dragした後の絶対位置にtargetViewを移す
    [sender setTranslation:CGPointZero inView:targetView];//targetViewの中心(メモリ)を現在位置にリセット
    
    //when touch up:http://stackoverflow.com/questions/6467638/detecting-pan-gesture-end
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        NSLog(@"touched up");
        
        speed = 0.5f;
        
        //現在位置(タッチアップした位置)を検出してアニメーション実行
        //animation
        [UIView animateWithDuration:0.2f
                         animations:^{
                            targetView.center =
                             CGPointMake(targetView.center.x,
                                         targetView.center.y - self.view.bounds.size.height);
                         }
                         completion:^(BOOL finished){
                             if(finished){
//                                 if(targetView.tag == 1){//reset original location
                                     targetView.frame = CGRectMake(100, 100, 150, 250);
//                                 }else{
//                                     
//                                 }
                             }
                         }];
    }
}



//first touch down
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch{
    
    //タッチ時に変形させるなど
    
    NSLog(@"first touch down : %d", gestureRecognizer.view.tag);
    
    return YES;
}


@end
