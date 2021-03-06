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

UIView *view1;//お札1
UIView *view2;//お札2
UIView *originalView;
CGRect originalRect;//original-location
double interval;
int counter;


UIImageView *viewYen;
UILabel *labelCounter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"self=%@", self);
    }
    return self;
}

-(void)initialization{
    counter = 0;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"start view did load");
    
    [self initialization];
    //アニメーションインターバル
    interval = 0.3f;
    
    
    originalRect = CGRectMake(100, 100, 200, 300);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    originalView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money_roll.png"]];
    originalView.frame = originalRect;
    [self.view addSubview:originalView];
    
    
    
    view1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money_1th.png"]];
    view1.frame = originalRect;
    view1.userInteractionEnabled = YES;
    view1.tag = 1;//1000円札のときは1、10000円札のときは2
    [self.view addSubview:view1];
    
    
    view2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money_1th.png"]];
    view2.frame = originalRect;
    view2.userInteractionEnabled = YES;
    view2.tag = 3;//1000円札のときは3、10000円札のときは4
    [self.view addSubview:view2];
    
    
    
    UIPanGestureRecognizer *panGest1 = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(drag:)];
    panGest1.delegate = self;
    [view1 addGestureRecognizer:panGest1];
    UIPanGestureRecognizer *panGest2 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(drag:)];
    panGest2.delegate = self;
    [view2 addGestureRecognizer:panGest2];
    
    
    
    viewYen = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_yen.png"]];
    viewYen.frame = CGRectMake(50, 10, 50, 50);
    [self.view addSubview:viewYen];
    
    labelCounter = [[UILabel alloc]initWithFrame:CGRectMake(viewYen.frame.origin.x + viewYen.bounds.size.width,
                                                            viewYen.frame.origin.y,
                                                            250, viewYen.bounds.size.height)];
    labelCounter.textColor = [UIColor grayColor];
    labelCounter.text = [NSString stringWithFormat:@"%d", counter];//formatで整えてもよい
    labelCounter.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelCounter];
    
    
    
    
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
    {//本当は位置判定して閾値以上ならカウント、以下ならカウントしないにする
        //All fingers are lifted.
        NSLog(@"touched up at interval=%f", interval);
        
        //カウンター発動
        
        if(targetView.tag % 2 == 1){
            counter += 1000;
            
        }else{
            counter += 10000;
        }
        labelCounter.text = [NSString stringWithFormat:@"%d", counter];
        
        //現在位置(タッチアップした位置)を検出してアニメーション実行
        //animation
        [UIView animateWithDuration:interval
                              delay:0.0
                             options:UIViewAnimationOptionCurveEaseIn//low->hight
                         animations:^{
                            targetView.center =
                             CGPointMake(targetView.center.x,
                                         -targetView.center.y/2);
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 targetView.frame = originalRect;
                                 
                                 //アニメーション終了したビューでない方を最前面に送る
                                 if(targetView.tag < 3){//view1のアニメーションが終了したときview2を最前面に
                                     [self.view bringSubviewToFront:view2];
                                 }else{//view2のアニメーションが終了したときview1を最前面に
                                     [self.view bringSubviewToFront:view1];
                                 }
                                 
                                 //数値を最前面に
                                 [self.view bringSubviewToFront:labelCounter];
                                 
                                 
                                 
                                 //1000円札の時でかつ、５回に１回程度10000万円にする
                                 if(arc4random() % 5 == 0 && ((UIImageView *)targetView).tag % 2 == 1){
                                     ((UIImageView *)targetView).image = [UIImage imageNamed:@"money_10th.png"];
                                     ((UIImageView *)targetView).tag ++;//= ((UIImageView *)targetView).tag + 1;
                                 }else{
                                     ((UIImageView *)targetView).image = [UIImage imageNamed:@"money_1th.png"];
                                     if(((UIImageView *)targetView).tag % 2 == 0){//１万円札のときだけマイナス１
                                         ((UIImageView *)targetView).tag --;
                                     }
                                 }
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
