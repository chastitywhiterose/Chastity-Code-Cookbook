/*chastity panel de pon*/

/*Part 1: Declaring variables and constants.*/

struct panel_player
{
 int size,color;
 SDL_Rect rect;
 int x,y;
};


struct panel_player player;

void player_init()
{
 /*set up the values of the player*/
 /*player.color=SDL_MapRGB(surface->format,255,255,0);*/
 player.size=36;
 player.rect.x=1*player.size;
 player.rect.y=1*player.size;
 player.rect.w=player.size;
 player.rect.h=player.size;
 player.x=4;
 player.y=4;
}

#define tetris_array_size 0x1000

/*main block structure*/
struct tetris_grid
{
 int array[tetris_array_size];
};

struct tetris_grid main_grid,temp_grid,match_grid;

int grid_width=10,grid_height=20;

/*main block structure*/
struct tetris_block
{
 int array[16];
 int color;
 int spawn_x,spawn_y; /*where block spawns on entry*/
 int x,y; /*current location of block*/
 int width_used; /*width of block actually used*/
 int id;
};

/*details of main block*/

struct tetris_block main_block,hold_block,temp_block; /*the structures which will be the main,hold,temp block*/


int moves=0; /*number of valid moves*/
int moves_tried=0; /*number of attempted moves*/
int last_move_spin=0; /*was the last move a t spin?*/
int last_move_fail; /*did the last move fail?*/
int back_to_back=0;
int score=0;
int combo=0;

char move_log[0x1000000]; /*large array to store moves*/

int empty_color=0x000000;

void grid_clear()
{
 int x,y;
 y=0;
 while(y<grid_height)
 {
  x=0;
  while(x<grid_width)
  {
   main_grid.array[x+y*grid_width]=empty_color;
   x+=1;
  }
  y+=1;
 }
}


/*all things about moving down*/
void down()
{
 player.y+=1;
 if(player.y==grid_height){player.y-=1;}
 else
 {
  move_log[moves]=move_id;
  moves++;
 }
}

/*all things about moving up*/
void up()
{
 player.y-=1;
 if(player.y<0){player.y+=1;}
 else
 {
  move_log[moves]=move_id;
  moves++;
 }
}

/*all things about moving right*/
void right()
{
 player.x+=1;
 if(player.x==grid_width-1){player.x-=1;}
 else
 {
  move_log[moves]=move_id;
  moves++;
 }
}

/*all things about moving left*/
void left()
{
 player.x-=1;
 if(player.x<0){player.x+=1;}
 else
 {
  move_log[moves]=move_id;
  moves++;
 }
}




int panel_match_count=0,match;

/*start of vertical matching function*/
int vmatch()
{
 int x,y,y1;
 int c,c1; /*colors testing*/
 panel_match_count=0;
 
 
  x=0;
  while(x<grid_width)
  {
   y=0;
   while(y<grid_height)
   {
    match=0;

    /*get the color at this index  if it is not empty, count the matches*/
    c=main_grid.array[x+y*grid_width];
    if(c!=empty_color)     
    {

     /*then go downwards and find matches*/
     y1=y;
     while(y1<grid_height)
     {
      c1=main_grid.array[x+y1*grid_width];
      if(c1==c){match++;}
      else{break;}
      y1++;
     }

     /*if found 3 or more matches*/
     if(match>=3)
     {
      panel_match_count+=match;
      /*printf("vertical match %d\n",match);*/
      while(y<y1)
      {
       match_grid.array[x+y*grid_width]=0xFFFFFF;
       y++;
      }
     }
         
    }
    
    y++;
   }
   
   x+=1;
  }
 
 return panel_match_count;
}
/*end of vertical matching function*/






/*start of horizontal matching function*/
int hmatch()
{
 int x,y,x1;
 int c,c1; /*colors testing*/
 panel_match_count=0;
 match=0;
 
  y=0;
  while(y<grid_height)
  {
    /*printf("checking row y=%d\n",y);*/
   x=0;
   while(x<grid_width)
   {
    match=0;
    /*printf("checking column x=%d\n",x);*/
     /*
      get the color at this index
      if it is not empty, count the matches
     */
     c=main_grid.array[x+y*grid_width];
     if(c!=empty_color)
     {


      /*then go rightwards and find matches*/
      x1=x;
      while(x1<grid_width)
      {
       c1=main_grid.array[x1+y*grid_width];
       if(c1==c){match++;}
       else{break;}
       x1++;
      }

        if(match>=3)
        {
         panel_match_count+=match;
         /*printf("horizontal match %d\n",match);*/
         while(x<x1)
         {
          match_grid.array[x+y*grid_width]=0xFFFFFF;
          x++;
         }
        }
         
     
     }
    
    x++;
   }
   
   y++;
  }
 
 return panel_match_count;
}
/*end of horizontal matching function*/


/*

this function uses both of the previously defined verical and horizonal matching functions

*/
int panel_match()
{
 int x,y,horizontal_matches,vertical_matches;

/*
now see if anything matches
if so, copy the matches to a separate grid
*/

 /*first we clear the match grid to all black*/
 y=0;
 while(y<grid_height)
 {
  x=0;
  while(x<grid_width)
  {
   match_grid.array[x+y*grid_width]=empty_color;
   x+=1;
  }
  y+=1;
 }

/*then these functions detect horizontal and vertical matches*/
horizontal_matches=hmatch();
vertical_matches=vmatch();


/*printf("horizontal_matches==%d\n",horizontal_matches);
printf("vertical_matches==%d\n",vertical_matches);*/

 /*then copy all found matches back to the main grid*/
 y=0;
 while(y<grid_height)
 {
  x=0;
  while(x<grid_width)
  {
   if(match_grid.array[x+y*grid_width]!=empty_color)
   {
    main_grid.array[x+y*grid_width]=0x000000;
   }
   x+=1;
  }
  y+=1;
 }

 return horizontal_matches+vertical_matches;
}




int panel_fall_count;

int panel_fall()
{
 int x,y,xcount,y1;

/* printf("Time to make lines fall\n");*/

panel_fall_count=0;

 y=grid_height;
 while(y>0)
 {
  y-=1;

  xcount=0;
  x=0;
  while(x<grid_width)
  {
   if(main_grid.array[x+y*grid_width]==empty_color)
   {
   
   
   y1=y;
   while(y1>0)
   {
    y1--;
    
    if(main_grid.array[x+y1*grid_width]!=empty_color)
    {
     main_grid.array[x+y*grid_width]=main_grid.array[x+y1*grid_width]; /*copy from space above*/
     main_grid.array[x+y1*grid_width]=empty_color; /*make space above empty now that is has been moved*/
     
     panel_fall_count++;
     break;
    }
    
   }
    
    xcount++;
   }
   
   x+=1;
  }



 }

 return panel_fall_count;
}

/*
 this function makes the puyo fall only one grid space and delay each time
 it makes it look like they are actually falling and is the superior version of the original function
*/
void panel_fall_one()
{
 int x,y,y1;
 panel_fall_count=0;
 x=0;
 while(x<grid_width)
 {
  y=grid_height-1;
  while(y>0 && main_grid.array[x+y*grid_width]!=empty_color)
  {
   y--;
  }
  while(y>0)
  {
   y1=y-1;
   if(main_grid.array[x+y1*grid_width]!=empty_color){panel_fall_count++;}
   main_grid.array[x+y*grid_width]=main_grid.array[x+y1*grid_width];
   main_grid.array[x+y1*grid_width]=empty_color;
   y--;
  }
  x+=1;
 }
}




/*
a very small but important function I wrote to delay a specified number of milliseconds
this has vast implications for Chaste Puyo and Chaste Panel. Those games are timing based unlike Chaste Tris.
*/

void chaste_delay(int delay)
{
 int t0,t1;

 t0=SDL_GetTicks();
 t1=t0+delay;

 while(t0<t1)
 {
  t0=SDL_GetTicks();
 }

}


/*flip the two panels at cursor and then try to check matches*/
void flip()
{
 int temp,matches;
 int x=player.x,y=player.y;
 temp=main_grid.array[x+y*grid_width];
 main_grid.array[x+y*grid_width]=main_grid.array[x+1+y*grid_width];
 main_grid.array[x+1+y*grid_width]=temp;
 
 /*if either of the spaces swapped is empty, test for potential fall*/
 if( main_grid.array[x+y*grid_width]==0  ||  main_grid.array[x+1+y*grid_width]==0 )
 {
   show_grid();
   chaste_delay(500);
   panel_fall_count=1;
   while(panel_fall_count!=0)
   {
    panel_fall_one();
   /*printf("fall==%d\n",x);*/
    show_grid();
    if(panel_fall_count!=0)
    {
     chaste_delay(100);
    }
   }

 }



 combo=0;
 
 /*loop that keeps going as long as there are any matches*/
 matches=1;
 while(matches)
 {
  /*test horizontal and vertical matches*/
  matches=panel_match();
  /*printf("matches==%d\n",matches);*/
  if(matches!=0)
  {
   combo++;
   score+=100*matches*combo;
   show_grid();
   chaste_delay(500);

   panel_fall_count=1;
   while(panel_fall_count!=0)
   {
    panel_fall_one();
   /*printf("fall==%d\n",x);*/
    show_grid();
    if(panel_fall_count!=0)
    {
     chaste_delay(100);
    }
   }

  }
  
 }

 move_log[moves]=move_id;
 moves++;
}

int colors[]={0xFF0000,0xFFFF00,0x00FF00,0x00FFFF,0x0000FF,0xFF00FF};
int color_index=0;

void more()
{

 int x,y;
 y=0;
 while(y<grid_height-1)
 {
  x=0;
  while(x<grid_width)
  {
   main_grid.array[x+y*grid_width]=main_grid.array[x+(y+1)*grid_width];
   x+=1;
  }
  y+=1;
 }
 
  x=0;
  while(x<grid_width)
  {
   main_grid.array[x+y*grid_width]=colors[color_index];
   color_index=(color_index+1)%6;
   x+=1;
  }
 
 move_log[moves]=move_id;
 moves++;
}


