//
//  NSObject+YLKVO.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/12/21.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "NSObject+YLKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "YLThread.h"


@interface YLObservationInfo: NSObject
@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) YLKVOBlock block;
//@property (nonatomic,strong)   NSThread * thread;
@end

@implementation YLObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer key:(NSString *)key block:(YLKVOBlock)block {
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    
    }
    return  self;
}
@end

static NSString * getterForSetter(NSString * setter) {
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString * key = [setter substringWithRange: range];
    NSString * firstChar = [[key substringToIndex: 1] lowercaseString];
    key = [key stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString: firstChar];
   // NSLog(@"key:%@",key);
    return key;
}

static NSString * setterMethodGet(NSString * getter) {
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    //NSLog(@"setter: %@:",setter);
    return setter;
}

static Class kvo_class(id self, SEL _cmd)
{
    //// 获取类的父类
    // NSLog(@" class name  :   %@",[class_getSuperclass(object_getClass(self)) class]);
    return class_getSuperclass(object_getClass(self));//object_getClass(self) ;
}

static void kvo_setter(id self, SEL _cmd, id newValue) {
    
    NSString * setterName = NSStringFromSelector(_cmd);
    
    NSString *getterName = getterForSetter(setterName);
    //NSLog(@"setterName :%@ ---getterNmae: %@ ",setterName,getterName);
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
#pragma mark - self属于子类还是父类
    //如果没有复写子类的clas方法，这里类名是子类类名，但是并不影响类实质上获取getter方法
    //复写方法后看到类名为message类名
    //NSLog(@"self属于子类还是父类 : %@",[self class]);
    id oldValue = [self valueForKey:getterName]; //实质上的类获取方法
    //其中receiver是指类的实例，super_class则是指该实例的父类。
    struct objc_super superClazz = {
        .receiver = self,  //这是实际消息接受者
        .super_class = class_getSuperclass(object_getClass(self))  //方法查找要到YL_类的父类中去找（因为self类名已经被别名为YL开头的kvo；类）
    };
    //objc_msgSendSuper 调用 objc_msgSendSuper 告诉系统去父类方法列表里面去找，
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    //为原来的key赋值
    objc_msgSendSuperCasted(&superClazz,_cmd,newValue);
    
   // id value2 = [self valueForKey:getterName]; //实质上的类获取方法
   // NSLog(@"%@ ====newValue====%@",value2,newValue);
    NSMutableArray *observers = objc_getAssociatedObject(self, &YLKVOAssociateObservers);
    dispatch_queue_t queueSerialbBack= objc_getAssociatedObject(self, &kYLDISPATCH_QUEUE_T_Observers);
    
    //[value getValue:&queueSerialbBack];
    //NSLog(@"%@",queueSerialbBack);
    for(YLObservationInfo *temp in observers) {
        if ([temp.key isEqualToString: getterName]) {
            
//            [self performSelector:@selector(runBlock) onThread: [YLThread networkRequestThreadName:@"YLObservation"] withObject:@"hoggen" waitUntilDone:YES];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                temp.block(self, getterName, oldValue, newValue);
//            });
            dispatch_async(queueSerialbBack, ^{
                temp.block(self, getterName, oldValue, newValue);
            });
        }
    }
    
    
}

@implementation NSObject (YLKVO)



-(void)YLAddObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(YLKVOBlock)block {
    
    NSLog( @"getterForSetter(%@) : %@",key,setterMethodGet(key));
    //获取设置方法
    SEL setterSelector = NSSelectorFromString(setterMethodGet(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);//用 class_getInstanceMethod 去获得 setKey: 的实现（Method）获取实例方法
    //[self haseSelector:method_getName(setterMethod)];
    //NSLog(@"setterMethod = %@   class = %@", NSStringFromSelector(method_getName(setterMethod)), NSStringFromClass([self class]));
    if (!setterMethod) {
        NSString * reason = [NSString stringWithFormat:@"Object %@ doesn not have a setter for key %@ ",self,key];
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: reason userInfo: nil];
    }
    
    Class clazz = object_getClass(self);
    NSLog(@"object_getClass(%@) : %@", clazz, object_getClass(self));
    NSString * className = NSStringFromClass(clazz);
    //
    NSLog(@"className == %@",className);
    if (![className hasPrefix: YLKVOClassPrefix]) {
        //创建子类，并赋予这个子类class方法，这时clazz的值已经是子类了，
        clazz = [self makeKvoClassWithOriginalClassName:className];
        NSLog(@"创建新的kvo类 === %@",NSStringFromClass(clazz));
        //将一个对象设置为别的类类型，这时调用[self class]返回的其实是YL_的子类，由于我们覆写了class的方法返回的使我们新创建kvo类的父类的class，所以看到的还是[self class]的类名
        Class c1 = object_setClass(self, clazz);
        NSLog(@"cl - %@", [c1 class]);
        NSLog(@"self - %@", [self class]);
        NSLog(@"modelRuntime的类名2- %@", object_getClass(self));
        
    }
    //添加我们自己kvo的类的实现方法，如果被观察的类没有实现它的setter方法，这时的self已经被别名了YL_开头的kvo子类，所以里面只有一个新建时添加的class方法
    if (![self haseSelector: setterSelector]) {
        const char * types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
        NSLog(@"添加我们自己kvo的类的实现方法，如果类没有实现它的setter方法");
//        [self performSelector:setterSelector onThread: [YLThread networkRequestThreadName:@"YLObservation"] withObject:@"hoggen" waitUntilDone:YES];
    }
    YLObservationInfo *info = [[YLObservationInfo alloc] initWithObserver:observer key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, &YLKVOAssociateObservers);
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self,&YLKVOAssociateObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    dispatch_queue_t queueSerial= objc_getAssociatedObject(self, &kYLDISPATCH_QUEUE_T_Observers);
       if (!queueSerial) {
            queueSerial = dispatch_queue_create("obser.queue", DISPATCH_QUEUE_SERIAL);
          // value = [NSValue valueWithBytes:&queueSerial objCType:@encode(dispatch_queue_t)];
           objc_setAssociatedObject(self, &kYLDISPATCH_QUEUE_T_Observers, queueSerial, OBJC_ASSOCIATION_RETAIN);
       }

    [observers addObject: info];
    
}

-(void)YLRemoveObserver:(NSObject *)observer forKey:(NSString *)key {
     NSMutableArray *observers = objc_getAssociatedObject(self, &YLKVOAssociateObservers);
    YLObservationInfo *infoToremove;
    for(YLObservationInfo * temp in observers) {
        if (temp.observer == observer && [temp.key isEqual: key]) {
            infoToremove = temp;
            break;
        }
    }
    [observers removeObject: infoToremove];
}

- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName {
    NSString * kvoClassName = [YLKVOClassPrefix stringByAppendingString: originalClazzName];
    Class classNew = NSClassFromString(kvoClassName);
    if (classNew) {
        return  classNew;
    }
    //不存在这个类，那么久新建它
    Class originClazz =  object_getClass(self);
    NSLog(@"kvoClassName : %@",kvoClassName);
    //    分配空间,创建类(仅在 创建之后,注册之前 能够添加成员变量)、添加类 superclass 类是父类   name 类的名字  size_t 类占的空间；运行时创建类的方法
    Class kvoClazz = objc_allocateClassPair(originClazz, kvoClassName.UTF8String, 0);
    //重写了 class 方法。隐藏这个子类的存在。最后 objc_registerClassPair() 告诉 Runtime 这个类的存在。
    Method clazzMethod = class_getInstanceMethod(originClazz, @selector(class));
      //获取方法的Type字符串(包含参数类型和返回值类型)
    const char * types = method_getTypeEncoding(clazzMethod);
    /**
     kvoClazz 参数表示需要添加新方法的类。
      @selector(class) 参数表示 selector 的方法名称，可以根据喜好自己进行命名。
     imp 即 implementation ，表示由编译器生成的、指向实现方法的指针。也就是说，这个指针指向的方法就是我们要添加的方法。
    types 表示我们要添加的方法的返回值和参数。
     */

    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    objc_registerClassPair(kvoClazz);
    return kvoClazz;
}

-(BOOL)haseSelector:(SEL)selector {
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    unsigned int ivarCount = 0;
    Method *methodList = class_copyMethodList(clazz, &methodCount);
    
    Ivar * ivars = class_copyIvarList(clazz, &ivarCount);
    
    NSLog(@"ivarCount : %@",@(ivarCount));
    for (unsigned int i = 0; i < ivarCount;  i++) {
        Ivar tempIvar = ivars[i];
        NSLog(@"className: %@, ivar_getName : %s ,selector : %@ ",NSStringFromClass(clazz),ivar_getName(tempIvar),NSStringFromSelector(selector));
    }
    
    
    for (unsigned int i = 0; i < methodCount;  i++) {
        SEL tempMeothod = method_getName(methodList[i]);
        NSLog(@"className: %@, tempMeothod : %@ ,selector : %@ ",NSStringFromClass(clazz),NSStringFromSelector(tempMeothod),NSStringFromSelector(selector));
    }
    for (unsigned int i = 0; i < methodCount;  i++) {
        SEL tempMeothod = method_getName(methodList[i]);
        if (tempMeothod == selector) {
            free(methodList);
            return YES;
            
        }
    }
     free(methodList);
    return false;
}
@end































