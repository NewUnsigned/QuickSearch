//
//  QuestionModel.h
//  RTHXiOSApp
//
//  Created by 融通汇信 on 15/8/25.
//  Copyright (c) 2015年 融通汇信. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface QuestionModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *qa_url;
@property (assign, nonatomic) NSInteger qa_id;

-(NSComparisonResult)compareModel:(QuestionModel *)model;

@end
