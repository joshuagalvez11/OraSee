# swip_change

COMP 490 Project
=======
Flutter project.

DataBase:
  - Firebase_Auth, Firebase_Cloud_FireStore
  
Feature：
  - Email & password SignIn & SignOut
  - Google Signin & SignOut
  - Facebook Signin & SignOut
  - Phone Login and Verify by OTP
    - when Signing, the format of Phone Number must follow the formate "+1 234 456 789"
    - after Signing, user can Edit their personal Infomation (Name, Email) in Setting Page
  - Screen Navigate by Swiping (HomePage, CommunityPage, SettingPage) with Bottom Navigation Bar
  - HomePage Set up
  - Setting Page Set up:
    - Show User Account Information
    - Edit User Account Information
    - Delete User Account
    - Edit Email Address
    - Reset Password
  - After LogOut, User cannot go back to Landing Page, Unless Delete the User

Tips:
 - cannot use same email address to login in facebook, google
 - the phone number format input have to follow +1 234 567 890

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
