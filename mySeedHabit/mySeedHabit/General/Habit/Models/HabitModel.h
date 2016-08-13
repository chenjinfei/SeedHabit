//
//  HabitModel.h
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MindNotesModel;

@interface HabitModel : NSObject


@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *logo_chosen_url;

@property (nonatomic, assign) NSInteger banner_id;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, assign) NSInteger mind_count;

@property (nonatomic, copy) NSString *creating_user_id;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, copy) NSString *iPrivate;

@property (nonatomic, copy) NSString *check_in_time;

@property (nonatomic, assign) NSInteger banner_type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *banner_url;

@property (nonatomic, assign) NSInteger members;

@property (nonatomic, assign) NSInteger joining_time;

@property (nonatomic, copy) NSString *hId;

@property (nonatomic, copy) NSString *reminder;

@property (nonatomic, copy) NSString *banner_quotation;

@property (nonatomic, copy) NSString *url_title;

@property (nonatomic, assign) NSInteger check_in_times;

@property (nonatomic, assign) NSInteger join_days;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSArray<MindNotesModel *> *mind_notes;


@end


