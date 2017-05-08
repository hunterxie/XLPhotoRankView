//
//  DMTool.h
//  DramaProject
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMLabel : UILabel

@end



/**
 *  UI工厂类
 */
@interface DMTool : NSObject
/**
 *  创建ImageView
 *
 *  @param frame   imageView rect
 *  @param imgName 图片名字  //内部实现contentFromFile;
 *  @param mode    mode
 *
 *  @return imageView
 */
+(UIImageView *)CreateImgViewWithFrame:(CGRect)frame withImgName:(NSString *)imgName withContentMode:(UIViewContentMode)mode;
/**
 *  创建一个label
 *
 *  @param frame         rect
 *  @param text          label.text
 *  @param font          font
 *  @param textAlignment 对齐方式
 *
 *  @return label
 */
+(DMLabel *)CreateLabelWithFrame:(CGRect)frame withText:(NSString *)text withFont:(UIFont *)font withTextAlign:(NSTextAlignment)textAlignment;

/**
 *  创建一个uibutton
 *
 *  @param frame   rect
 *  @param bgImage btn 的背景图
 *  @param img     btn的image
 *  @param title   按钮的title
 *  @param method  方法
 *  @param target  添加到什么对象上
 *
 *  @return btn
 */
+(UIButton *)CreateBtnWithFrame:(CGRect)frame withBGImg:(NSString *)bgImage withImg:(NSString *)img withTitle:(NSString *)title selector:(SEL)method target:(id)target;
/**
 *  返回一个button
 *
 *  @param frame      rect
 *  @param normalImg  未选中的图片
 *  @param seletedImg 选中的图片
 *  @param method     方法
 *  @param target     对象
 *
 *  @return button
 */
+(UIButton *)CreateBtnWithFrame:(CGRect)frame withNormalImg:(NSString *)normalImg withSelectedImg:(NSString *)seletedImg  selector:(SEL)method target:(id)target;
/**
 *  返回一个button
 *
 *  @param frame       rect
 *  @param normalText  未选中的文字
 *  @param seletedText 选中后的文字
 *  @param method      方法
 *  @param target      对象
 *
 *  @return button
 */
+(UIButton *)CreateBtnWithFrame:(CGRect)frame withNormalText:(NSString *)normalText withSelectedText:(NSString *)seletedText  selector:(SEL)method target:(id)target;
/**
 *  返回一个tableview
 *
 *  @param frame    rect
 *  @param delegate datasource和delegate代理
 *  @param style    tableview的类型
 *
 *  @return tableview
 */
+(UITableView *)CreateTableViewWithFrame:(CGRect)frame withDataSourceAndDelegate:(id)delegate withStyle:(UITableViewStyle)style;
/**
 *  返回一个textfield
 *
 *  @param frame         rect
 *  @param text          默认字符串
 *  @param placehold
 *  @param font          字体
 *  @param textAlignment 对齐方式
 *
 *  @return textfield
 */
+(UITextField *)CreateTextFieldWithFrame:(CGRect)frame  withText:(NSString *)text withPlacehold:(NSString *)placehold withFont:(UIFont *)font withTextAlign:(NSTextAlignment)textAlignment;

/**
 *  颜色转图片
 *
 *  @param color color
 *
 *  @return return
 */
+(UIImage*) createImageWithColor:(UIColor*)color;
/**
 *  从照片中直接识别二维码
 *  @param qrCodeImage 带二维码的图片
 *  @param myQRCode    二维码包含的内容
 */
+ (void)readQRCodeFromImage:(UIImage *)qrCodeImage myQRCode:(void(^)(NSString *qrString,NSError *error))myQRCode;

//星座
+ (NSString *)getAstroWithMonth:(int)m day:(int)d;


@end
