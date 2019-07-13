//
//  ViewController.m
//  Gesture_base
//
//  Created by 谢鑫 on 2019/7/11.
//  Copyright © 2019 Shae. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic,strong)NSMutableArray *imageList;
@property(nonatomic,assign)NSInteger imageIndex;
@end

@implementation ViewController
-(NSMutableArray *)imageList{
    if (_imageList==nil) {
        _imageList=[NSMutableArray array];
        for (int i=0; i<4; i++) {
            NSString *imageName=[NSString stringWithFormat:@"%d",i];
            UIImage *image=[UIImage imageNamed:imageName];
            [_imageList addObject:image];
        }
    }
    return _imageList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageView.userInteractionEnabled=YES;
    
    //单击，单手指
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    //单击
    singleTap.numberOfTapsRequired=1;
    //单手指
    singleTap.numberOfTouchesRequired=1;
    //添加到imageView
    [self.imageView addGestureRecognizer:singleTap];
    
    //双击，双手指
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    //单击
    doubleTap.numberOfTapsRequired=2;
    //单手指
    doubleTap.numberOfTouchesRequired=2;
    //添加到imageView
    [self.imageView addGestureRecognizer:doubleTap];
    
    //捏合手势
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [self.imageView addGestureRecognizer:pinchGesture];
    
    //旋转手势
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    [self.imageView addGestureRecognizer:rotationGesture];
    
    _imageIndex=0;
    //滑动手势默认是向右的
    UISwipeGestureRecognizer *swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    [self.imageView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:swipeLeft];
    
    //拖动手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:panGesture];
    
    //长按手势
    UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.imageView addGestureRecognizer:longPressGesture];
    
}
-(void)singleTap:(UITapGestureRecognizer*)gesture{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"单击+单手指" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"双击+双手指" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)pinch:(UIPinchGestureRecognizer*)gesture{
    NSLog(@"%s,scale: %f",__func__,gesture.scale);
    CGFloat scale=gesture.scale;
    self.imageView.transform=CGAffineTransformScale(gesture.view.transform, scale, scale);
    //不要使用 CGAffineTransformMake(<#CGFloat a#>, <#CGFloat b#>, <#CGFloat c#>, <#CGFloat d#>, <#CGFloat tx#>, <#CGFloat ty#>),会有一些bug
   
    //一定要把scale的值重置为1，否则会影响缩放效果，即缩放比例会在上一次的基础上进行缩小/放大
    gesture.scale=1;
}

-(void)rotation:(UIRotationGestureRecognizer*)gesture{
    NSLog(@"%s, rotation:%f, velocity:%f",__func__,gesture.rotation,gesture.velocity);
    CGFloat rotation=gesture.rotation;
    self.imageView.transform=CGAffineTransformRotate(gesture.view.transform, rotation);
    //一定要把rotation的值重置为0，否则会影响旋转效果。
    gesture.rotation=0;
}
-(void)swipe:(UISwipeGestureRecognizer*)gesture{
    NSInteger imageCount=self.imageList.count;
    if (gesture.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (_imageIndex>=imageCount-1) return;
        self.imageView.image=self.imageList[++_imageIndex];
    }else if (gesture.direction==UISwipeGestureRecognizerDirectionRight){
        if (_imageIndex<=0) return;
        self.imageView.image=self.imageList[--_imageIndex];
    }
}
-(void)pan:(UIPanGestureRecognizer*)gesture{
    //获取位置变化量
    CGPoint translation=[gesture translationInView:self.view];
    gesture.view.center=CGPointMake(gesture.view.center.x+translation.x, gesture.view.center.y+translation.y);
    //要重置一下gesture的位置变化量
    [gesture setTranslation:CGPointZero inView:self.view];
}
-(void)longPress:(UILongPressGestureRecognizer*)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"开始长按");
            self.stateLabel.text=[NSString stringWithFormat:@"开始长按......"];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"结束长按");
            self.stateLabel.text=@"结束长按";
            break;
            
        default:
            NSLog(@"长按中");
            self.stateLabel.text=@"长按中";
            break;
    }
}

@end
