//
//  CommonUtils.m
//  TrainTicket
//
//  Created by xuguoxing on 12-12-8.
//  Copyright (c) 2012年 xuguoxing. All rights reserved.
//

#import "CommonUtils.h"
#import "CommonColor.h"
//#import "AlertView.h"

/*void alertMessage(NSString *title ,NSString *message){
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

void alertView(NSString *title){
    [AlertView showMsg:title duration:2.0f];
}*/

UITextField *createPlainTextFiled(CGRect frame)
{
    UITextField *textFiled = [[UITextField alloc] initWithFrame:frame];
	textFiled.font = [UIFont systemFontOfSize:15];
	textFiled.textColor = [CommonColor brownTextColor];
	textFiled.backgroundColor = [UIColor clearColor];
	textFiled.borderStyle = UITextBorderStyleNone;
	textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
	textFiled.autocorrectionType = UITextAutocorrectionTypeNo;
	textFiled.autocapitalizationType  = UITextAutocapitalizationTypeNone;
	textFiled.returnKeyType = UIReturnKeyNext;
	textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textFiled;
}

BOOL openURL(NSURL *url){
	/*if (! [[UIApplication sharedApplication] canOpenURL:url]) {
		alertMessage([NSString stringWithFormat:@"通过浏览器打开页面错误"],@"请确认您是否关闭safari的访问限制");
		return NO;
	}*/
	[[UIApplication sharedApplication] openURL:url];
	return YES;
}

BOOL openURLString(NSString *urlString){
	NSURL *url = [NSURL URLWithString:urlString];
	return openURL(url);
}

UILabel *labelForNavTitle(NSString *title){
    UILabel *label = [[UILabel alloc] init];
	[label setFont:[UIFont systemFontOfSize:18]];
	[label setTextColor:[CommonColor blackTextColor]];
	[label setText:title];
    [label sizeToFit];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	return label;
}

void alertMessage(NSString *title ,NSString *message){
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}
