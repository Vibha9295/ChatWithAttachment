//
//  RegisterVC.m
//  ChatWithAttachment
//
//  Created by vibha on 7/5/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import "RegisterScreenVC.h"
#import "UserScreenVC.h"

@interface RegisterScreenVC ()

@end

@implementation RegisterScreenVC
@synthesize txtEmail,txtPassword,txtUserName;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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



- (IBAction)btnRegister:(id)sender {
    [self signUp];
    
    
}
-(void)signUp{
    mdata = [[NSMutableDictionary alloc]init];
    [txtEmail resignFirstResponder];
    [txtUserName resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    NSString *strPassword = txtPassword.text;
    NSString *strUsername = txtUserName.text;
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString1 = [txtUserName.text stringByTrimmingCharactersInSet:charSet];
    BOOL validEmail=[self validateEmail:txtEmail.text];
    BOOL validFname = [self validateName:txtUserName.text];
    if ([txtUserName.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please enter user name" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
        [alertController addAction:ok];
    }
    else if ([strUsername length]<3 || [strUsername length]>20) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please enter user name between 3 to 20 characters" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
        [alertController addAction:ok];
        
        
    }
    
    else if ([trimmedString1 isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please enter valid user name" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
        [alertController addAction:ok];
        
    }
    
    else if (!validFname)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please enter valid user name" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
        [alertController addAction:ok];
        
        
    }
    else if ([txtEmail.text isEqualToString:@""]) {
        
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
    else if (!validEmail){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please enter valid email address" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
        [alertController addAction:ok];
        
    }
    
    
    else if ([strPassword length]<8 || [strPassword length]>15)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Password Should be between 8 to 15 characters!" preferredStyle:UIAlertControllerStyleAlert];
        
        
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
        
        //NSDictionary *dic = @{@"user_name":txtUserName.text,@"user_email":txtEmail.text,@"user_password":txtPassword.text};
      //  NSLog(@"%@",dic);
        
        ref = [[FIRDatabase database] reference];
        
        
        [[FIRAuth auth] createUserWithEmail:txtEmail.text                               password:txtPassword.text
                                 completion:^(FIRUser *user, NSError *error) {
                                     
                                     if(error){
                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"The email address is already in use by another account." preferredStyle:UIAlertControllerStyleAlert];
                                         
                                         
                                         [self presentViewController:alertController animated:YES completion:nil];
                                         
                                         UIAlertAction* ok = [UIAlertAction
                                                              actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                                              {
                                                                  txtEmail.text = @"";
                                                                  
                                                              }];
                                         [alertController addAction:ok];
                                         
                                     }
                                     else{
                                        // NSLog(@"%@",user);
                                         
                                         
                                         user = [FIRAuth auth].currentUser;
                                         if (user) {
                                             userIDAuth = user.uid;
                                             emailAuth = user.email;
                                             
                                             mdata = [[NSMutableDictionary alloc]init];
                                             
                                             //[mdata setValue:_txt_email.text forKey:@"email"];
                                             // [mdata setValue:_txt_name.text forKey:@"name"];
                                             //[mdata setValue:@"iOS" forKey:@"deviceType"];
                                             [mdata setValue:txtEmail.text forKey:@"user_email"];
                                             [mdata setObject:txtUserName.text forKey:@"user_name"];
                                             [mdata setObject:txtPassword.text forKey:@"user_password"];
                                             [mdata setObject:userIDAuth forKey:@"user_id"];
                                             
                                             [[[ref child:@"users"] child: userIDAuth] updateChildValues:mdata];
                                             txtEmail.text = @"";
                                             txtPassword.text = @"";
                                             txtUserName.text = @"";
                                             UserScreenVC *objUserScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserScreenVC"];
                                             objUserScreenVC.strLoginID = userIDAuth;
                                             objUserScreenVC.strLoginEmail = emailAuth;
                                             
                                             [self.navigationController pushViewController:objUserScreenVC animated:YES];
                                         }
                                     }
                                 }];
        
    }
    
    
}
-(BOOL)validateName:(NSString *)name
{
    NSString *nameRegex = @"^[A-Za-z]+[a-zA-Z0-9'_.-]*$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:name];
}

-(BOOL)validPassword:(NSString *)pwd
{
    
    NSString *nameRegex = @"^.*(?=.{8,})(?=..*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:pwd];
    
}

-(BOOL)validateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z.]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (IBAction)btnSignIn:(id)sender {
    LoginScreenVC *objLoginScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreenVC"];
    
    [self.navigationController pushViewController:objLoginScreenVC animated:YES];
}
@end
