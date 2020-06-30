#import "UploadController.h"
#import "GCDWebUploader.h"
#import "SJXCSMIPHelper.h"

@interface UploadController ()<GCDWebUploaderDelegate>
/* webServer */
@property (nonatomic, strong) GCDWebUploader *webServer;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation UploadController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 文件存储位置
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 创建webServer,设置根目录
    self.webServer = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    // 设置代理
    self.webServer.delegate = self;
    self.webServer.allowHiddenItems = YES;
    // 开启
    if ([_webServer start]) {
        NSString *ipString = [SJXCSMIPHelper deviceIPAdress];
        NSLog(@"ip地址为：%@", ipString);
        NSUInteger port = self.webServer.port;
        NSLog(@"开启监听的端口为：%zd", port);
        NSString *url =[NSString stringWithFormat:@"%@: %lu",ipString, (unsigned long)port];
        self.tipLabel.text = url;
    } else {
        NSLocalizedString(@"GCDWebServer not running!", nil);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.webServer stop];
    self.webServer = nil;
}

#pragma mark - <GCDWebUploaderDelegate>
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
}

@end
