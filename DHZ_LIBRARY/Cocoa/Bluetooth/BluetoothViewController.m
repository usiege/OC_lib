//
//  BluetoothViewController.m
//  DHZ_LIBRARY
//
//  Created by 先锋电子技术 on 16/5/17.
//  Copyright © 2016年 Hello,world!. All rights reserved.
//

#import "BluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


static CBCentralManager* _centralManager = nil;
#define     BUSINESS_SERVICE_UUID_STRING     @"0000FF10-0000-0040-4855-4959554e0000"//

@interface BluetoothViewController () <CBCentralManagerDelegate,CBPeripheralDelegate>

@end

@implementation BluetoothViewController


+ (CBCentralManager *)shareCentralManager{
    return _centralManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 指定当前类为代理对象，所以其需要实现CBCentralManagerDelegate协议
    // 如果queue为nil，则Central管理器使用主队列来发送事件
    dispatch_queue_t queue = dispatch_get_main_queue();
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
    
    
    //该方法下不出现系统蓝牙开启提示，此情况是在options参数为nil时的
//    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:nil];
    
}

- (IBAction)testBtnClick:(id)sender {
    [self searchPeripherals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchPeripherals{
    // 查找Peripheral设备
    // 如果第一个参数传递nil，则管理器会返回所有发现的Peripheral设备。
    // 通常我们会指定一个UUID对象的数组，来查找特定的设备
    
    NSLog(@"查找蓝牙外围设备");
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark -CBCentralManagerDelegate

//1.创建Central管理器时，管理器对象会调用代理对象的centralManagerDidUpdateState:方法。我们需要实现这个方法来确保本地设备支持BLE。
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Central Update State");
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            break;
            
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
            
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
            
        default:
            break;
    }
}

//2.Central端的首要任务是发现正在广告的Peripheral设备，以备后续连接。我们可以调用CBCentralManager实例的scanForPeripheralsWithServices:options:方法来发现正在广告的Peripheral设备。
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discover name : %@", peripheral.name);
    NSLog(@"advertisement data is: %@\n RSSI is :%@",advertisementData,RSSI);
    
    // 当我们查找到Peripheral端时，我们可以停止查找其它设备，以节省电量
//    [_centralManager stopScan];
//    NSLog(@"Scanning stop");
    
    // 3.在查找到Peripheral设备后，我们可以调用CBCentralManager实例的connectPeripheral:options:方法来连接Peripheral设备。
//    [_centralManager connectPeripheral:peripheral options:nil];
//    
//    //查找服务
//    NSDictionary *scanOption = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)};
//    [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BUSINESS_SERVICE_UUID_STRING]] options:scanOption];
    
}

//4.如果连接成功，则会调用代码对象的centralManager:didConnectPeripheral:方法，我们可以实现该方法以做相应处理。另外，在开始与Peripheral设备交互之前，我们需要设置peripheral对象的代理，以确保接收到合适的回调。
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    peripheral.delegate = self;
    
    //5.建立到Peripheral设备的连接后，我们就可以开始查询数据了。首先我们需要查找Peripheral设备中可用的服务。由于Peripheral设备可以广告的数据有限，所以Peripheral设备实际的服务可能比它广告的服务要多。我们可以调用peripheral对象的discoverServices:方法来查找所有的服务。
    [peripheral discoverServices:nil];
    
}


#pragma mark -CBPeripheralDelegate
//6.当调用上述方法时，peripheral会调用代理对象的peripheral:didDiscoverServices:方法。Core Bluetooth创建一个CBService对象的数组，数组中的元素是peripheral中找到的服务。
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"Discover Service");
    
    for (CBService *service in peripheral.services)
    {
        NSLog(@"Discovered service %@", service);
    }
    
    if (peripheral.services.count == 0) return;
    CBService* service = peripheral.services[0];
    //7.假设我们已经找到感兴趣的服务，接下来就是查询服务中的特性了。为了查找服务中的特性，我们只需要调用CBPeripheral类的discoverCharacteristics:forService:方法，
    [peripheral discoverCharacteristics:nil forService:service];
    
}
//8.当发现特定服务的特性时，peripheral对象会调用代理对象的peripheral:didDiscoverCharacteristicsForService:error:方法。在这个方法中，Core Bluetooth会创建一个CBCharacteristic对象的数组，每个元素表示一个查找到的特性对象。
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"Discover Characteristics");
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"Discovered characteristic %@", characteristic);
        //9.一个特性包含一个单一的值，这个值包含了Peripheral服务的信息。在获取到特性之后，我们就可以从特性中获取这个值。只需要调用CBPeripheral实例的readValueForCharacteristic:方法即可。
        [peripheral readValueForCharacteristic:characteristic];
        
        //11.虽然使用readValueForCharacteristic:方法读取特性值对于一些使用场景非常有效，但对于获取改变的值不太有效。对于大多数变动的值来讲，我们需要通过订阅来获取它们。当我们订阅特性的值时，在值改变时，我们会从peripheral对象收到通知。
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

//10.当我们读取特性中的值时，peripheral对象会调用代理对象的peripheral:didUpdateValueForCharacteristic:error:方法来获取该值。如果获取成功，我们可以通过特性的value属性来访问它
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    
    NSLog(@"Data = %@", data);
    
    if (error)
    {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
