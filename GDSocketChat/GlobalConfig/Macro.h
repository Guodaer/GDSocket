//
//  Macro.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


//默认颜色
#define color_333 Hex_Color(0x333333,1.0)
#define color_666 Hex_Color(0x666666,1.0)
#define color_999 Hex_Color(0x999999,1.0)
#define color_ccc Hex_color(0xcccccc,1.0)
#define allViewCustomColor rgb_Color(244,244,244)
//Log
#ifdef DEBUG
#define GDLog( s, ... ) NSLog( @"^_^[%@:(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
# define GDLog(...)
#endif

#define GDWeakSelf(weakSelf) __weak typeof(self) weakSelf = self;



//屏宽高
#define GScreenWidth  [UIScreen mainScreen].bounds.size.width
#define GScreenHeight  [UIScreen mainScreen].bounds.size.height

//color  0x......
#define Hex_Color(rgbValue,alp) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]

#define rgb_Color(r,g,b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define GDImage(imgName) [UIImage imageNamed:imgName]

#define font(size) [UIFont systemFontOfSize:size]

#define UIApplicationSingleton ((AppDelegate *) [[UIApplication sharedApplication] delegate])
//iPhone X
#define IS_IPHONE_X (GScreenHeight == 812.0f) ? YES : NO
#define Height_NavContentBar 44.0f
#define Height_StatusBar (IS_IPHONE_X==YES)?44.0f: 20.0f
#define Height_NavBar (IS_IPHONE_X==YES)?88.0f: 64.0f
#define Height_TabBar (IS_IPHONE_X==YES)?83.0f: 49.0f
#define Height_TabbarSafeBottom (IS_IPHONE_X==YES)?34.0f: 0.0f

#define APP_CHAT_UID @"2"
#define APP_CHAT_TOUID @"1"
#define SOCKET_Address @"192.168.11.179"
#endif /* Macro_h */
