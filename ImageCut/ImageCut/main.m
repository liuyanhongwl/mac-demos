//
//  main.m
//  ImageCut
//
//  Created by Hong on 16/8/12.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        if (argc < 2) {
            NSLog(@"need input file");
            return 0;
        }
        
        //input file
        NSString *inputFile = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        
        
        //output file
        NSString *outputPath = [inputFile stringByDeletingPathExtension];
        
        
        //tile size
        CGFloat tileSize = 256;
        
        
        //load image
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:inputFile];
        CGSize size = image.size;
        if ([image representations].firstObject) {
            NSImageRep *imageRep = [image representations].firstObject;
            size.width = imageRep.pixelsWide;
            size.height = imageRep.pixelsHigh;
        }
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        CGImageRef imageRef = [image CGImageForProposedRect:&rect context:nil hints:nil];
        
        
        //calculate rows and colums
        NSInteger rows = ceil(size.height / tileSize);
        NSInteger cols = ceil(size.width / tileSize);
        
        
        //generate tiles
        for (int y = 0; y < rows; y ++) {
            for (int x = 0; x < cols; x ++) {
                CGRect tileRect = CGRectMake( x * tileSize, y * tileSize, tileSize, tileSize);
                CGImageRef tileImageRef = CGImageCreateWithImageInRect(imageRef, tileRect);
                
                NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:tileImageRef];
                NSData *data = [imageRep representationUsingType:NSJPEGFileType properties:nil];
                CGImageRelease(tileImageRef);
                
                NSString *path = [outputPath stringByAppendingFormat:@"_%i_%i.jpg", x, y];
                NSLog(@"%@", path);
                [data writeToFile:path atomically:NO];
            }
        }
        
    }
    return 0;
}
