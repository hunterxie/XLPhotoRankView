//
//  DMTool.m
//  DramaProject
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 xll. All rights reserved.
//

#import "DMTool.h"

@implementation DMLabel



@end

/**
 An array of NSNumber objects, shows the best order for path scale search.
 e.g. iPhone3GS:@[@1,@2,@3] iPhone5:@[@2,@3,@1]  iPhone6 Plus:@[@3,@2,@1]
 */
static NSArray *_NSBundlePreferredScales() {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}
/**
 Add scale modifier to the file name (without path extension),
 From @"name" to @"name@2x".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
static NSString *_NSStringByAppendingNameScale(NSString *string, CGFloat scale) {
    if (!string) return nil;
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
}
@implementation DMTool

+(UIImageView *)CreateImgViewWithFrame:(CGRect)frame withImgName:(NSString *)imgName withContentMode:(UIViewContentMode)mode
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    if(imgName){
        if (![imgName isEqualToString:@""]) {
            NSString *path = [self GetImagePathWithImgStr:imgName];
            if (path) {
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                imageView.image = image;
            }else {
                imageView.image = [UIImage imageNamed:imgName];
            }
        }
    }
    imageView.contentMode = mode;
    imageView.userInteractionEnabled = YES;
    return imageView;
}
/**
 *  根据image字符串 查看是否有file路径 如果有 直接返回路径 如果没有 直接返回nil
 *
 *  @param name image文件字符串
 *
 *  @return 路径
 */
+(NSString *)GetImagePathWithImgStr:(NSString *)name
{
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;
    
    // If no extension, guess by system supported (same as UIImage).
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSArray *scales = _NSBundlePreferredScales();
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = _NSStringByAppendingNameScale(res, scale);
        for (NSString *e in exts) {
            path = [[NSBundle mainBundle] pathForResource:scaledName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) return nil;
    return path;
}
+(DMLabel *)CreateLabelWithFrame:(CGRect)frame withText:(NSString *)text withFont:(UIFont *)font withTextAlign:(NSTextAlignment)textAlignment
{
    
    if (text&&![text isKindOfClass:[NSString class]]) {
        text = [NSString stringWithFormat:@"%@",text];
    }
    
    DMLabel * label = [[DMLabel alloc] initWithFrame:frame];
    if (text&&![text isKindOfClass:[NSNull class]]) {
        
        label.text = text;
    }
    label.font = font;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textAlignment = textAlignment;
    return label;
}
+(UIButton *)CreateBtnWithFrame:(CGRect)frame withBGImg:(NSString *)bgImage withImg:(NSString *)img withTitle:(NSString *)title selector:(SEL)method target:(id)target
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    button.frame = frame;
    if(bgImage){
        NSString *path = [self GetImagePathWithImgStr:bgImage];
        if (path) {
            [button setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        }else {
            [button setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
        }
    }
    if(img){
        NSString *path = [self GetImagePathWithImgStr:img];
        if (path) {
            [button setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        }else {
            [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }
    }
    if(title && ![title isKindOfClass:[NSNull class]]){
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (target && method) {
        [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}
+(UIButton *)CreateBtnWithFrame:(CGRect)frame withNormalImg:(NSString *)normalImg withSelectedImg:(NSString *)seletedImg selector:(SEL)method target:(id)target
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    button.frame = frame;
    if(normalImg){
        NSString *path = [self GetImagePathWithImgStr:normalImg];
        if (path) {
            [button setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        }else {
            [button setImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
        }
        
    }
    if(seletedImg){
        NSString *path = [self GetImagePathWithImgStr:seletedImg];
        if (path) {
            [button setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
        }else {
            [button setImage:[UIImage imageNamed:seletedImg] forState:UIControlStateSelected];
        }
    }
    if (target && method) {
        [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}
+(UIButton *)CreateBtnWithFrame:(CGRect)frame withNormalText:(NSString *)normalText withSelectedText:(NSString *)seletedText selector:(SEL)method target:(id)target
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if(normalText && ![normalText isKindOfClass:[NSNull class]]){
        [button setTitle:normalText forState:UIControlStateNormal];
    }
    if(seletedText && ![seletedText isKindOfClass:[NSNull class]]){
        [button setTitle:seletedText forState:UIControlStateSelected];
    }
    if (target && method) {
        [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}
+(UITableView *)CreateTableViewWithFrame:(CGRect)frame withDataSourceAndDelegate:(id)delegate withStyle:(UITableViewStyle)style
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    return tableView;
}
+(UITextField *)CreateTextFieldWithFrame:(CGRect)frame withText:(NSString *)text withPlacehold:(NSString *)placehold withFont:(UIFont *)font withTextAlign:(NSTextAlignment)textAlignment
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.text = text;
    textField.placeholder = placehold;
    textField.font = font;
    textField.textAlignment = textAlignment;
    return textField;
}
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (void)readQRCodeFromImage:(UIImage *)qrCodeImage myQRCode:(void(^)(NSString *qrString,NSError *error))myQRCode
{
    
    UIImage * srcImage = qrCodeImage;
    if (nil == srcImage) {
        myQRCode(nil,[NSError errorWithDomain:@"未传入图片" code:0 userInfo:nil]);
        return;
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    if (features.count) {
        CIQRCodeFeature *feature = [features firstObject];
        
        NSString *result = feature.messageString;
        
        myQRCode(result,nil);
    }
    else{
        myQRCode(nil,[NSError errorWithDomain:@"未能识别出二维码" code:0 userInfo:nil]);
        return;
    }
    
}
+ (NSString *)getAstroWithMonth:(int)m day:(int)d
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    if ([result isEqualToString:@"魔羯"]) {
        return @"魔羯";
    }
    else if ([result isEqualToString:@"水瓶"])
    {
        return @"水瓶";
    }
    else if ([result isEqualToString:@"双鱼"])
    {
        return @"双鱼";
    }
    else if ([result isEqualToString:@"白羊"])
    {
        return @"白羊";
    }
    else if ([result isEqualToString:@"金牛"])
    {
        return @"金牛";
    }
    else if ([result isEqualToString:@"双子"])
    {
        return @"双子";
    }
    else if ([result isEqualToString:@"巨蟹"])
    {
        return @"巨蟹";
    }
    else if ([result isEqualToString:@"狮子"])
    {
        return @"狮子";
    }
    else if ([result isEqualToString:@"处女"])
    {
        return @"处女";
    }
    else if ([result isEqualToString:@"天秤"])
    {
        return @"天秤";
    }
    else if ([result isEqualToString:@"天蝎"])
    {
        return @"天蝎";
    }
    else if ([result isEqualToString:@"射手"])
    {
        return @"射手";
    }
    else
    {
        return @"";
    }
    
    
    return result;
}


@end



