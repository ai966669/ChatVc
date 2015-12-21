//
//  imageInOc.h
//  learn1
//
//  Created by ai966669 on 4/29/15.
//
//

//#import "dataWithOss.h"
#import "ZYQAssetPickerController.h"
#import <UIKit/UIKit.h>

@protocol AssetPickerDelegate <NSObject>

-(void)finishPick:(NSArray *)images;

@end

@interface AssetPicker : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>{
    UIImagePickerController *myPicker;
}
@property (nonatomic, weak) id <AssetPickerDelegate> oneAssetPickerDelegate;
- (void)getPictureFromCamera;
- (void)getPictureFromAlbum;
-(void)initMyPicker;
@end
