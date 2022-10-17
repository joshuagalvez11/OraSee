intent("Hello",p=>{
    p.play("(Hello|hi,there)");
});

intent("what's your name",p=>{
   p.play("I am your daddy"); 
});

intent("open the video page",p=>{
   p.play({command:"video"}); 
   p.play("Open the video Page");
});

intent("open the community page",p=>{
   p.play({command:"community"}); 
   p.play("Open the community Page");
});

intent("open the setting page",p=>{
   p.play({command:"setting"}); 
   p.play("Open the setting Page");
});

intent("Account Information",p=>{
   p.play({command:"Account Information"}); 
   p.play("Open the setting Page");
});

intent("Email Change",p=>{
   p.play({command:"Email Change"}); 
   p.play("Open the setting Page");
});

intent("Password Change",p=>{
   p.play({command:"Password Change"}); 
   p.play("Open the setting Page");
});

intent("Sign Out",p=>{
   p.play({command:"signout"}); 
   p.play("you have already Sign out the account!");
});

