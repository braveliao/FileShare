//
//  ViewController.m
//  FileShare
//
//  Created by liaoyong on 12/13/13.
//  Copyright (c) 2013 redcdn.cn. All rights reserved.
//

#import "ViewController.h"
#import "THFTPAPI.h"
#import "FileListViewController.h"
#import "FTPFileUpload.h"
#import "FTPFileDownload.h"

@interface ViewController ()

@property (nonatomic, strong) FTPFileUpload *fileAdapter;
@property (nonatomic, strong) FTPFileDownload *fileDownAdapter;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fileAdapter = [[FTPFileUpload alloc] init];
    self.fileDownAdapter = [[FTPFileDownload alloc] init];
    //upload
}

- (IBAction)ftpUploadBtn:(id)sender
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"];
    [self.fileAdapter InitFTPInfo:@"liaoyong" Password:@"redcdn" UploadPath:@"ftp://192.168.1.107" LocalFilePath:filePath];

    NSLog(@"upload file...");
}

- (IBAction)ftpDownloadBtn:(id)sender
{
    [self.fileDownAdapter ftpDownload];
    NSLog(@"download file...");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtn:(id)sender
{
    char *host = "192.168.1.107";
    int port = 21;
    char *user = "liaoyong";
    char *pwd = "redcdn";
    int result = ftp_connect(host, port, user, pwd);
    NSLog(@"result: %d",result);
    if (result < 0) {
        NSLog(@"login ftp error,result: %d",result);
        return;
    }
    
    FileListViewController *ctrView = [[FileListViewController alloc] init];
    [self.navigationController pushViewController:ctrView animated:YES];
}
@end
