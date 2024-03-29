//
//  TaoTwitterViewModel.m
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterViewModel.h"
#import "TaoNetManager.h"

@interface TaoTwitterViewModel ()
@property(nonatomic, assign) NSInteger since_id;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TaoTwitterViewModel

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSInteger)since_id {
    if (!_since_id) {
        _since_id = 0;
    }
    return _since_id;
}

- (void)loadDataWithcompleteBlock:(void (^)(NSError *))complete notModified:(void (^)(NSError *))notModifiedBlock parameters:(id)parameter {
    
    [[TaoNetManager sharedInstance] requestWithPath:@"statuses/friends_timeline.json" parameters:nil
                                         completion:^(NSError *error, Taostatuses *resultObject) {
        if (!error) {
            self.dataSource = [resultObject.statuses mutableCopy];
            Taostatus *md = [self.dataSource lastObject];
            self.maxID = md.idstr.integerValue - 1;
        }
        complete(error);

    }];
    
}

- (void)loadDataCacheBlock:(void (^)(NSError *))cacheBlock {
    [[TaoNetManager sharedInstance]requestWithPath:@"statuses/friends_timeline.json" parameters:[NSDictionary dictionary] cacheBlock:^(NSError *error, Taostatuses *resultObject) {
        self.dataSource = [resultObject.statuses mutableCopy];
        Taostatus *md = [self.dataSource lastObject];
        self.maxID = md.idstr.integerValue - 1;
        cacheBlock(error);
    }];
    
}

- (void)loadMoreBlock:(void (^)(NSError *))complete parameters:(id)parameter {

   [[TaoNetManager sharedInstance] requestWithPath:@"statuses/friends_timeline.json" parameters:[NSDictionary dictionaryWithObject:@(self.maxID) forKey:@"max_id"] completion:^(NSError *error, Taostatuses *resultObject) {
       if (!error) {
           [self.dataSource addObjectsFromArray:resultObject.statuses];
           Taostatus *md = [self.dataSource lastObject];
           self.maxID = md.idstr.integerValue - 1;
       }else {
//#warning 无网络
       }
       complete(error);
    }];
    
}
@end
