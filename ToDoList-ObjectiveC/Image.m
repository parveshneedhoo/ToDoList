//
//  Image.m
//  ToDoList-ObjectiveC
//
//  Created by Kunal on 14/11/2022.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import <AFNetworking/AFNetworking.h>
#import <AFURLSessionManager.h>
#import <AVFoundation/AVFoundation.h>

@implementation Image

+ (NSString *)uploadimage:(UIImage *)image addPath:(NSString *)path{
    NSData *imageData =UIImagePNGRepresentation(image);
    __block NSString *imageUrl;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://api.cloudinary.com/v1_1/dssmidp0h/image/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileData:imageData name:@"file" fileName:path mimeType:[self getMimeType:imageData]];
        [formData appendPartWithFormData:[@"873728271175549" dataUsingEncoding:NSUTF8StringEncoding] name:@"api_key"];
        [formData appendPartWithFormData:[@"dm1jfy0d" dataUsingEncoding:NSUTF8StringEncoding] name:@"upload_preset"];

    } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
       progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"Upload Progress %@", uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Upload Error: %@", error);
        } else {
            NSLog(@"Upload Sucesss %@", response);
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSLog(@" VALUE %@", [responseDict valueForKey:@"url"]);
            NSString *url = [responseDict valueForKey:@"url"];
            imageUrl = url;
        }
    }];
    
    [uploadTask resume];
    return imageUrl;
}

+ (NSString *) getMimeType:(NSData *) data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}


+ (void)takeImage{
    
}

@end
