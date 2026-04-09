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
