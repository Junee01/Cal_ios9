//
//  ViewController.m
//  CalculatorApp
//
//  Created by PARKSANGJUN on 2016. 2. 1..
//  Copyright © 2016년 PARKSANGJUN. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
//속성에 대한 get, set method 를 생성한다.
@synthesize curValue;
@synthesize totalCurValue;
@synthesize curStatusCode;
@synthesize displayLabel;

- (void)viewDidLoad {
    [self ClearCalculation];    //계산기 화면 초기화
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//자동 회전 지원 여부를 리턴한다. 여기서는 ok
- (BOOL)shouldAutorotate
{
    return YES;
}
//회전 방향 지원 유무를 리턴
-(UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//Label에 문자열을 출력하는 메서드
-(void)DisplayInputValue:(NSString *)displayText
{
    NSString *CommaText;
    CommaText = [self ConvertComma:displayText];
    [displayLabel setText:CommaText];
}

//계산 결과를 화면에 출력하는 메서드
-(void)DisplayCalculationValue
{
    NSString *displayText;
    displayText = [NSString stringWithFormat:@"%g", totalCurValue];
    [self DisplayInputValue:displayText];
    curInputValue = @"";
}

//계산기 초기화 메서드
-(void) ClearCalculation
{
    curInputValue = @"";
    curValue = 0;
    totalCurValue = 0;
    
    [self DisplayInputValue:curInputValue];
    
    curStatusCode = STATUS_DEFAULT;
}

//천 원 단위를 표시하는 메서드
-(NSString *) ConvertComma:(NSString *)data
{
    if(data == nil) return nil;
    if([data length] <= 3) return data;
    
    NSString *integerString = nil;
    NSString *floatString = nil;
    NSString *minusString = nil;
    
    //소수점을 찾는다.
    NSRange pointRange = [data rangeOfString:@"."];
    if(pointRange.location == NSNotFound){
        //소수점이 없다.
        integerString = data;
    }
    else {
        //소수점 이하 영역을 찾습니다.
        NSRange r;
        r.location = pointRange.location;
        r.length = [data length] - pointRange.location;
        floatString = [data substringWithRange:r];
        
        //정수부 영역을 찾습니다.
        r.location = 0;
        r.length = pointRange.location;
        integerString = [data substringWithRange:r];
    }
    
    //음수 부호를 찾습니다.
    NSRange minusRange = [integerString rangeOfString:@"-"];
    if(minusRange.location != NSNotFound){  //음수 부호가 있습니다.
        minusString = @"-";
        integerString = [integerString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    //세 자리 단위로 콤마를 찍는다.
    NSMutableString *integerStringCommaInserted = [[NSMutableString alloc] init];
    NSUInteger integerStringLength = [integerString length];
    int idx = 0;
    while (idx < integerStringLength){
        [integerStringCommaInserted appendFormat:@"%C",[integerString characterAtIndex:idx]];
        if((integerStringLength-(idx+1))%3==00&&integerStringLength!=(idx+1)){
            [integerStringCommaInserted appendString:@","];
        }
           idx++;
    }
    
    NSMutableString *returnString = [[NSMutableString alloc] init];
    if(minusString != nil) [returnString appendString:minusString];
    if(integerStringCommaInserted != nil) [returnString appendString:integerStringCommaInserted];
    if(floatString != nil) [returnString appendString:floatString];
    
    return returnString;
}

//숫자와 소수점 버튼을 누르면 호출되는 메서드
-(IBAction)digitPressed:(UIButton *)sender
{
    NSString *numPoint = [[sender titleLabel] text];
    curInputValue = [curInputValue stringByAppendingFormat:numPoint];
    [self DisplayInputValue:curInputValue];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operationText = [[sender titleLabel] text];
    
    if([@"+" isEqualToString:operationText])
    {
        [self Calculation:curStatusCode CurStatusCode:STATUS_PLUS];
    }
    else if([@"-" isEqualToString:operationText])
    {
        [self Calculation:curStatusCode CurStatusCode:STATUS_MINUS];
    }
    else if([@"X" isEqualToString:operationText])
    {
        [self Calculation:curStatusCode CurStatusCode:STATUS_MULTIPLY];
    }
    else if([@"/" isEqualToString:operationText])
    {
        [self Calculation:curStatusCode CurStatusCode:STATUS_DIVISION];
    }
    else if([@"C" isEqualToString:operationText])
    {
        [self ClearCalculation];
    }
    else if([@"=" isEqualToString:operationText])
    {
        [self Calculation:curStatusCode CurStatusCode:STATUS_RETURN];
    }
}

-(void) Calculation:(kStatusCode)StatusCode CurStatusCode:(kStatusCode)cStatusCode;
{
    switch(StatusCode)
    {
        case STATUS_DEFAULT:
            [self DefaultCalculation];  //현재 상태가 default
            break;
        case STATUS_DIVISION:
            [self DivisionCalculation]; //division
            break;
        case STATUS_MULTIPLY:
            [self MultiplyCalculation]; //multiply
            break;
        case STATUS_MINUS:
            [self MinusCalculation];    //minus
            break;
            
        case STATUS_PLUS:
            [self PlusCalculation];     //plus
            break;
    }
    curStatusCode = cStatusCode;
}

- (void)DefaultCalculation
{
    curValue = [curInputValue doubleValue]; //초기화 이후 처음 입력된 값에 대한 처리
    totalCurValue = curValue;
    
    [self DisplayCalculationValue];
}

- (void)PlusCalculation
{
    curValue = [curInputValue doubleValue]; //입력된 값에 대한 덧셈 처리
    totalCurValue = totalCurValue + curValue;
    
    [self DisplayCalculationValue];
}

- (void)MinusCalculation
{
    curValue = [curInputValue doubleValue]; //입력된 값에 대한 뺄셈 처리
    totalCurValue = totalCurValue - curValue;
    
    [self DisplayCalculationValue];
}

- (void)MultiplyCalculation
{
    curValue = [curInputValue doubleValue]; //입력된 값에 대한 곱셈 처리
    totalCurValue = totalCurValue * curValue;
    
    [self DisplayCalculationValue];
}

- (void)DivisionCalculation
{
    curValue = [curInputValue doubleValue]; //입력된 값에 대한 나눗셈 처리
    totalCurValue = totalCurValue / curValue;
    
    [self DisplayCalculationValue];
}

@end
