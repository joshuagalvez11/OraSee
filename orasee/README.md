COMP 490 Project
=======
Flutter project.

DataBase:
  - Firebase_Auth, Firebase_Cloud_FireStore

Feature：
  - anonymous SignIn 
    - User Click Need Assistance Button in the Landing Page and Jump to the Home Page Directly
  - Email & password SignIn & SignOut
  - Google Signin & SignOut
  - Facebook Signin & SignOut
  - Phone Login and Verify by OTP
    - when Signing, the format of Phone Number must follow the formate "+1 234 456 789"
    - after Signing, user can Edit their personal Infomation (Name, Email) in Setting Page

Pages:
  - HomePage Set up
   - if already has user login then stay in Home Page
  - Setting Page Set up:
    - Show User Account Information
    - Edit User Account Information
    - Delete User Account
    - Edit Email Address
    - Reset Password
  - After LogOut, User cannot go back to Landing Page, Unless Delete the User


Pages Navigation:
  - Screen Navigate by Swiping (HomePage, CommunityPage, SettingPage) with Bottom Navigation Bar
  - HomePage (Video Call Page) swip down to Test Page (Page for Text Recognition Feature)

Voice Navigation:
  - Package == Alan Ai
  - be able to use Voice to Navigate different pages
  - be able to use Voice to Sign out account
  - be able to Interacte with AI (Hello, what's you name...)


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
