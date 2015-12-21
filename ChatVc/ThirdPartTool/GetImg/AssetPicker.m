//
//  imageInOc.m
//  learn1
//
//  Created by ai966669 on 4/29/15.
//
//

#import "AssetPicker.h"
#import "ZYQAssetPickerController.h"
#import "ChatVc-Swift.h"
@implementation AssetPicker
@synthesize oneAssetPickerDelegate;
-(void)getPictureFromCamera{
        [self initMyPicker];
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: sourceType]) {
            //            相机不能被调用,返回1
        }else{
//            NSString *mediaType = AVMediaTypeVideo;
            if ([HelpFromOc isCameraAvalible]){
            myPicker.sourceType = sourceType;
            UIViewController *vc = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
            [vc presentViewController:myPicker animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请在设备的 设置-隐私-相机 中允许访问相机。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
}
- (void)getPictureFromAlbum{
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
//            相册权限不允许
        }else{
            UIViewController *vc = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            [ZYQAssetPickerController initSize:(vc.view.frame.size.width-10)/4];
            picker.maximumNumberOfSelection = 10;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups=NO;
            picker.delegate=self;
            [vc presentViewController:picker animated:YES completion:nil];
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }

            }];
        }
}
-(void)initMyPicker{
    if(myPicker==nil){
        //        3.初始化picker
        myPicker = [[UIImagePickerController alloc] init];//初始化
        //        3.1将picker代理设置成自己
        myPicker.delegate = self;
        //        3.2设置可编辑
        //        myPicker.allowsEditing = YES;//设置可编辑
    }
}
#pragma mark –
#pragma mark Camera View Delegate Methods
//点击相册中的图片或者照相机照完后点击use 后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        //如果打开相册
        [picker dismissViewControllerAnimated:YES completion:nil];
//        image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        return ;
    }
    else{
        //照相机
        [picker dismissViewControllerAnimated:YES completion:nil];
        image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
    }
    //NSData   *myRecInDataOfImage=UIImageJPEGRepresentation(image, 0);
    NSMutableArray *rOfImageStoreInLocal=[[NSMutableArray alloc] initWithObjects:image, nil];
    [oneAssetPickerDelegate finishPick:rOfImageStoreInLocal];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //取消获取照片 返回2
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//    NSLog(@"%lf %lf",self.webView.frame.size.height,self.webView.frame.size.width);
    [picker dismissViewControllerAnimated:YES completion:nil];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        dispatch_async(dispatch_get_main_queue(), ^{
////            //            pageControl.numberOfPages=assets.count;
////        });
//        NSMutableArray *rOfImageStoreInLocal=[[NSMutableArray alloc] init];
//        for (int i=0; i<assets.count; i++) {
//            ALAsset *asset=assets[i];
////            NSData   *myRecInDataOfImage=UIImageJPEGRepresentation(tempImg, 0);
//            [rOfImageStoreInLocal addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
//        }
//        [oneAssetPickerDelegate finishPick:rOfImageStoreInLocal];
//    });
    NSMutableArray *rOfImageStoreInLocal=[[NSMutableArray alloc] init];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        //            NSData   *myRecInDataOfImage=UIImageJPEGRepresentation(tempImg, 0);
        [rOfImageStoreInLocal addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
    }
    [oneAssetPickerDelegate finishPick:rOfImageStoreInLocal];
}
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //取消获取照片 返回2
}
@end
