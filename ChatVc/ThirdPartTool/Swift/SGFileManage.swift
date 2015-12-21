//
//  SGFileManage.swift
//  SuperGina
//
//  Created by huawenjie on 15/9/14.
//  Copyright (c) 2015年 anve. All rights reserved.
//

class SGFileManage {
    static let defaultManage = SGFileManage()
    //保存在图片文件夹里
    func getTheImagePath(imageName: String) -> String{
        
        //获取DocumentPath 文件夹目录
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentPath = path[0]
        let fileManager = NSFileManager.defaultManager()

        
        let imageDocPath = documentPath.stringByAppendingString("/\(FileofImage)")
        
        do {
            try fileManager.createDirectoryAtPath(imageDocPath, withIntermediateDirectories: true, attributes: nil)
            let imagePath = imageDocPath.stringByAppendingString("/\(imageName)")
            return imagePath
        }catch let error as NSError {
            print("\(error.description)")
        }
        return ""
        
    }
    
    func getImage(name:String) -> UIImage? {
        let imagePath = getTheImagePath(name)
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(imagePath) {
            let image = UIImage(contentsOfFile: imagePath)
            
            return image
        }
        return nil
    }
    func saveToDocument(image:UIImage, withImageName imageName:String) -> Bool{
        
        let filePath = getTheImagePath(imageName)
        return saveToDocument(image, withFilePath: filePath)
    }
    func saveToDocument(image: UIImage!, withFilePath filePath: String) -> Bool{
        if filePath == "" {
            return false
        }
        var imageData: NSData?
        
        let url = NSURL(string: filePath)
        //获取文件扩展名
        let extention = url!.pathExtension
        if extention == "png" {
            imageData = UIImagePNGRepresentation(image)
        } else {
            imageData = UIImageJPEGRepresentation(image, 0)
        }
        if imageData == nil || imageData!.length <= 0 {
            return false
        }
        
        return imageData!.writeToFile(filePath, atomically: true)

    }
}
