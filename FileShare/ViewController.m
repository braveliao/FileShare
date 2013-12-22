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
#import "FTPFileList.h"
#import "Util.h"

@interface ViewController ()

@property (nonatomic, strong) FTPFileUpload *fileAdapter;
@property (nonatomic, strong) FTPFileDownload *fileDownAdapter;
@property (nonatomic, strong) FTPFileList   *fileListAdapter;
@end

@implementation ViewController

@synthesize ipTextField, userNameTextfield, passWordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fileAdapter = [[FTPFileUpload alloc] init];
    self.fileDownAdapter = [[FTPFileDownload alloc] init];
    self.fileListAdapter = [[FTPFileList alloc] init];
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
    char *host = [Util convertStringToChar:self.ipTextField.text];
    int port = 21;
    char *user = [Util convertStringToChar:self.userNameTextfield.text];
    char *pwd = [Util convertStringToChar:self.passWordTextField.text];
    int socketfd = ftp_connect(host, port, user, pwd);
    NSLog(@"result: %d",socketfd);
    if (socketfd < 0) {
        NSLog(@"login ftp error,result: %d",socketfd);
        return;
    }
    
    char *dirPath = "/";
    void *data ;
    unsigned long long data_len = 0;
    int ss = ftp_list(socketfd, dirPath, &data, &data_len);
    NSLog(@"ftp_list_result:%d",ss);
    NSString *dirString = [[NSString alloc] initWithBytes:data length:data_len encoding:NSUTF8StringEncoding];
    NSArray *dataArray = [Util dealDirData:dirString];
    NSLog(@"dataArray:%@",dataArray);
    
    FileListViewController *ctrView = [[FileListViewController alloc] init];
    ctrView.dataArray = dataArray;
    ctrView.currentPath = @"/";
    [self.navigationController pushViewController:ctrView animated:YES];
}
@end
