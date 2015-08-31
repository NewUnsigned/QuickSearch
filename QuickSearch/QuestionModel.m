//
//  QuestionModel.m
//  RTHXiOSApp
//
//  Created by 融通汇信 on 15/8/25.
//  Copyright (c) 2015年 融通汇信. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

-(NSComparisonResult)compareModel:(QuestionModel *)model
{
   return [[NSNumber numberWithUnsignedInteger:self.qa_id] compare:[NSNumber numberWithUnsignedInteger:model.qa_id]];
}

@end
