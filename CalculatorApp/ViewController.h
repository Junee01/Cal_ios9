//
//  ViewController.h
//  CalculatorApp
//
//  Created by PARKSANGJUN on 2016. 2. 1..
//  Copyright © 2016년 PARKSANGJUN. All rights reserved.
//

#import <UIKit/UIKit.h>

//현재 상태에 대한 상태 열거형
typedef enum {
    STATUS_DEFAULT = 0, //초기화 상태(c)
    STATUS_DIVISION,    //(/)누르면 나누기 상태로
    STATUS_MULTIPLY,    //(x)누르면 곱하기 상태로
    STATUS_MINUS,       //(-)누르면 빼기 상태로
    STATUS_PLUS,        //(+)누르면 더하기 상태로
    STATUS_RETURN       //(=)누르면 결과 상태로
} kStatusCode;

@interface ViewController : UIViewController {
    double curValue;            //현재 입력된 값을 저장하는 프로퍼티
    double totalCurValue;       //최종 계산값을 저장하는 프로퍼티
    NSString *curInputValue;    //현재 입력된 문자열을 저장하는 프로퍼티
    kStatusCode curStatusCode;
}

//숫자 버튼을 클릭할 경우 발생하는 이벤트를 처리하는 메서드
- (IBAction) digitPressed:(UIButton *)sender;
//기능 버튼을 클릭할 경우 발생하는 이벤트를 처리하는 메서드
- (IBAction) operationPressed:(UIButton *)sender;

@property Float64 curValue;             //현재 입력된 값을 프로퍼티로 선언
@property Float64 totalCurValue;        //최종 결과값을 프로퍼티로 선언
@property kStatusCode curStatusCode;    //현재 상태를 저장하는 값을 프로퍼티로 선언

//표시 Label을 참조하기 위한 아웃렛 선언
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@end

