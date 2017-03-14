//
//  ViewController.m
//  移除未读消息动画
//
//  Created by shaokan on 17/3/6.
//  Copyright © 2017年 GDT. All rights reserved.
//

#define RADIUS 60

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIView *myView;
    UIView *mySubView;
    
    UIBezierPath *myBezierPath;
    CAShapeLayer *myShapeLayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    myView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, RADIUS, RADIUS)];
    myView.backgroundColor = [UIColor redColor];
    myView.layer.cornerRadius = RADIUS/2;
    [myView setUserInteractionEnabled:YES];
    
    
    
    [self.view.layer addSublayer:myView.layer];
    UIPanGestureRecognizer *gest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    
    [self.view addGestureRecognizer:gest];
}

-(void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint point = [panGestureRecognizer translationInView:self.view];
    

    if(!mySubView){
        mySubView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, RADIUS, RADIUS)];
        mySubView.backgroundColor = [UIColor redColor];
        mySubView.layer.cornerRadius = RADIUS/2;

        [self.view.layer addSublayer:mySubView.layer];
    }
    
    myView.center = CGPointMake(point.x + myView.center.x, point.y + myView.center.y);
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    //圆1原点
    float x1 = mySubView.center.x;
    float y1 = mySubView.center.y;
    
    //圆2原点
    float x2 = myView.center.x;
    float y2 = myView.center.y;
    
    CGPoint contrlPoint = [self getCenterPointOfPoint1:mySubView.center beetwnPoint2:myView.center];
    
    //斜率
    double k = (y2- y1)/(x2 - x1);
    //斜角
    float angle = atan(k) * 180.0 / M_PI;
    //斜边
    float hypotenuse = sqrt((y2- y1)*(y2- y1) + (x2 - x1)*(x2 - x1));
    //水平偏转角度
    float angle2 = acos(RADIUS/hypotenuse) * 180.0 / M_PI;
    
    //X轴、Y轴偏移
    float x = cos((angle2-angle)*M_PI/180.0) * RADIUS;
    float y = sin((angle2-angle)*M_PI/180.0) * RADIUS;
    
    NSLog(@"%f - %f   - (%f,%f)",angle2,angle,x,y);
    
    if (!myBezierPath) {
        myBezierPath = [UIBezierPath bezierPath];
    }
    [myBezierPath removeAllPoints];
    
    NSLog(@"%f-%f",contrlPoint.x,contrlPoint.y);
    [myBezierPath moveToPoint:CGPointMake(x1 + x,y1 - y)];
    [myBezierPath addQuadCurveToPoint:CGPointMake(x2 - x, y2 - y) controlPoint:CGPointMake(contrlPoint.x, y1 - y-2)];
    [myBezierPath addLineToPoint:CGPointMake(x2, y2)];
    [myBezierPath addLineToPoint:CGPointMake(x1, y1)];
    [myBezierPath closePath];
    
    
    if (!myShapeLayer) {
        myShapeLayer  =[CAShapeLayer layer];
        myShapeLayer.strokeColor = [[UIColor blueColor]CGColor];//线条颜色
        myShapeLayer.fillColor = [[UIColor redColor]CGColor];//填充色
        myShapeLayer.lineWidth = 0.1;//线条宽度
    }
    [myShapeLayer removeFromSuperlayer];
    
    myShapeLayer.path = myBezierPath.CGPath;//设置路径
    
    [self.view.layer addSublayer:myShapeLayer];
    
    //需要判断方向来确定四个点的坐标
    
    
//    sqrt();
//    acos(<#double#>)
}

-(CGPoint)getCenterPointOfPoint1:(CGPoint)point1 beetwnPoint2:(CGPoint)point2{
//    return CGPointMake(point1.x + (point2.x-point1.x)/2, point1.y + (point2.y - point1.y)/2);
    return CGPointMake(point1.x + (point2.x-point1.x)/2, point1.y + (point2.y - point1.y)/2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
