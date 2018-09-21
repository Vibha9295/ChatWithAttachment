//
//  ViewController.m
//  ChatWithAttachment
//
//  Created by vibha on 7/5/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import "LoginScreenVC.h"

@interface LoginScreenVC ()

@end

@implementation LoginScreenVC
@synthesize txtEmail,txtPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    self.handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       
                   }];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [[FIRAuth auth] removeAuthStateDidChangeListener:_handle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSignInAct:(id)sender {
    mdata = [[NSMutableDictionary alloc]init];
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    
    if ([txtEmail.text isEqualToString:@""]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please enter email address" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
        [alertController addAction:ok];
        
        
    }
    else if ([txtPassword.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please enter password" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
        [alertController addAction:ok];
        
    }
    
    else
    {
        
       // NSDictionary *dic = @{@"email_id":txtEmail.text,@"password":txtPassword.text};
        //NSLog(@"%@",dic);
        
        ref = [[FIRDatabase database] reference];
        
        
        [[FIRAuth auth] signInWithEmail:txtEmail.text
                               password:txtPassword.text
                             completion:^(FIRUser *user, NSError *error){
                                     
                                     if(error){
                                         
                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                                                                message:@"Email address or password invalid." preferredStyle:UIAlertControllerStyleAlert];
                                         
                                         
                                         [self presentViewController:alertController animated:YES completion:nil];
                                         
                                         UIAlertAction* ok = [UIAlertAction
                                                              actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                                              {
                                                                  txtEmail.text = @"";
                                                                  txtPassword.text = @"";
                                                              }];
                                         [alertController addAction:ok];
                                         
                                     }
                                     else{
                                         
                                       //   NSLog(@"%@",user);
                                         emailAuth = user.email;
                                         userIDAuth = user.uid;
                                         
                                         UserScreenVC *objUserScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserScreenVC"];
                                         objUserScreenVC.strLoginEmail = emailAuth;
                                         objUserScreenVC.strLoginID = userIDAuth;
                                         
                                         [self.navigationController pushViewController:objUserScreenVC animated:YES];
                                     }
                                 }];
        
    }

}

- (IBAction)btnSignUpAct:(id)sender {
    RegisterScreenVC *objRegisterScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterScreenVC"];
    
    [self.navigationController pushViewController:objRegisterScreenVC animated:YES];
}
@end
