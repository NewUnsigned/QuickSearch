//
//  RTHXQuestionVC.h
//  RTHXiOSApp
//
//  Created by 融通汇信 on 15/8/25.
//  Copyright (c) 2015年 融通汇信. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^refreshQuestionListBlock)();

@interface RTHXQuestionWebVC : UIViewController
@property (strong, nonatomic) NSString *urlString;
@property (copy, nonatomic) refreshQuestionListBlock refreshBlock;
@end
