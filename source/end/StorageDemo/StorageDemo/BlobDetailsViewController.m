/*
 Copyright 2013 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "BlobDetailsViewController.h"
#import "StorageService.h"

@interface BlobDetailsViewController ()

@end

@implementation BlobDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set our labels with the blob properties
    self.lblName.text = [self.blob objectForKey:@"name"];
    self.lblUrl.text = [self.blob objectForKey:@"url"];
    NSString *contentType = [[self.blob objectForKey:@"properties"] objectForKey:@"Content-Type"];
    self.lblContentType.text = contentType;
    
    //Attempt to load the image using the URL from the blob
    if ([contentType isEqualToString:@"image/jpeg"]) {
        NSURL *url = [NSURL URLWithString:[self.blob objectForKey:@"url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Handle loading the image from a SAS URL if necessary
- (IBAction)tappedLoadWithSAS:(id)sender {
    //Get the SAS for the existing blob
    StorageService *storageService = [StorageService getInstance];
    [storageService getSasUrlForNewBlob:[self.blob objectForKey:@"name"] forContainer:self.containerName withCompletion:^(NSString *sasUrl) {
        //The SAS provides us direct access to the Blob
        //so we can use that to set the image with the URL.
        NSURL *url = [NSURL URLWithString:sasUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];        
        self.imageView.image = image;
    }];
}
@end
