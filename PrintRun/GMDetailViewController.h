//
//  GMDetailViewController.h
//  PrintRun
//
//  Created by EndoTsuyoshi on 2014/05/10.
//  Copyright (c) 2014年 tsuyoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
