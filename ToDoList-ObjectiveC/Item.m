//
//  Item.m
//  ToDoList-ObjectiveC
//
//  Created by Kunal on 08/11/2022.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import <sqlite3.h>
@implementation Item

- (instancetype)initWithName:(NSString *)name andTopic:(NSString *)topic andImage:(UIImage *)image{
    if(self =[super init]){
        //initialize properties
        self.name = name;
        self.topic = topic;
        self.image = image;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name andTopic:(NSString *)topic andImagePath:(NSString *)path{
    if(self =[super init]){
        //initialize properties
        self.name = name;
        self.topic = topic;
        self.path = path;
    }
    return self;
}

+ (NSArray *)fetchItems{
    return @[
    ];
}

@end
