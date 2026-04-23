/*28 There is neither Jew nor Greek, there is neither slave nor free, there is neither male nor female—for all of you are one in Christ Jesus. 29 And if you belong to Christ, then you are Abraham’s descendants, heirs according to the promise.*/

int demo_galatians()
{
  sdl_clear();  /*clear the screen before we begin writing*/

  cursor_left=main_font.char_scale*8;

  main_font.char_scale=8; 


  putstr("\nGalatians Chapter 3\n\n");

  main_font.char_scale=4; 

  putstr("28 There is neither Jew nor Greek, there is neither slave nor free, there is neither male nor female-for all of you are one in Christ Jesus.\n\n");
  putstr("29 And if you belong to Christ, then you are Abraham's descendants, heirs according to the promise.\n");

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/

 return 0;
}


int demo_lucifer()
{
  sdl_clear();  /*clear the screen before we begin writing*/

  cursor_left=main_font.char_scale*8;

  main_font.char_scale=8; 


  putstr("\nIsaiah Chapter 14\n\n");

  main_font.char_scale=2; 

  putstr("12 Look how you have fallen from the sky,O shining one, son of the dawn! You have been cut down to the ground, O conqueror of the nations!");
  putstr("13 You said to yourself, 'I will climb up to the sky. Above the stars of El I will set up my throne. I will rule on the mountain of assembly on the remote slopes of Zaphon.");
  putstr("14 I will climb up to the tops of the clouds; I will make myself like the Most High!'");
  putstr("15 But you were brought down to Sheol, to the remote slopes of the Pit.");
  putstr("16 Those who see you stare at you, they look at you carefully, thinking: 'Is this the man who shook the earth, the one who made kingdoms tremble?");
  putstr("17 Is this the one who made the world like a wilderness, who ruined its cities and refused to free his prisoners so they could return home?'");
  putstr("18 As for all the kings of the nations, all of them lie down in splendor, each in his own tomb.");
  putstr("19 But you have been thrown out of your grave like a shoot that is thrown away. You lie among the slain, among those who have been slashed by the sword, among those headed for the stones of the Pit, as if you were a mangled corpse.");
  putstr("20 You will not be buried with them, because you destroyed your land and killed your people. The offspring of the wicked will never be mentioned again.\n");

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/

 return 0;
}


















