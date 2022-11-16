//
//  ViewController.h
//  ToDoList-ObjectiveC
//
//  Created by Kunal on 08/11/2022.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Cloudinary/Cloudinary.h>

@interface ItemsViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *imgPickerCObj;
    UIImage *image;
}


@end

