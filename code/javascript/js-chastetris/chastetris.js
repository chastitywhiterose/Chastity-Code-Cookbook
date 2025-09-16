/*
 Chaste Tris: JavaScript Edition

 This is a JavaScript port of Chaste Tris originally written in C. To play the original, download it for free on Steam:
 
 https://store.steampowered.com/app/1986120/Chaste_Tris/
*/

/*Part 1: Declaring variables and constants.*/

/*the width and height of the game and the canvas and its context are global variables that must be available anywhere.*/
var width,height,cvs,ctx;

function init_canvas()
{
 cvs=document.getElementById("canvas");
 width=cvs.width;
 height=cvs.height;
 ctx=cvs.getContext("2d");
 ctx.fillStyle="#000000";
 ctx.fillRect(0,0,width,height);
}

/*official size of a tetris field*/
var grid_width=10,grid_height=20;

var main_grid,temp_grid; /*global tetris field grids*/

var main_block={},hold_block={},temp_block={}; /*global tetris block objects*/

main_block.array=[];

main_grid={}; //empty object
main_grid.array=[]; //empty array

temp_grid={}; //empty object
temp_grid.array=[]; //empty array

var max_block_width=4; /* the max width of any tetris block*/
var blocks_used=7; //set to one for only long boi mode
var hold_used=0;
var moves=0; /*number of valid moves*/
var moves_tried=0; /*number of attempted moves*/
var last_move_spin=0; /*was the last move a t spin?*/
var last_move_fail; /*did the last move fail?*/
var back_to_back=0;
var score=0;
var combo=0;

var move_log=[];
var move_id='?';

var lines_cleared=0,lines_cleared_last=0,lines_cleared_total=0;

var empty_color=0x000000;

/*used to clear the tetris field at the beginning of the game but also later on if necessary for a restart*/

function tetris_clear_screen()
{
 var x,y;
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

tetris_clear_screen(); //call the function we juse defined

console.log(main_grid.array);

/*
This next section is very important. It defines all 7 blocks as arrays of 16 elements (4x4).
*/

var block_array_i=
[
 0,0,0,0,
 1,1,1,1,
 0,0,0,0,
 0,0,0,0,
];

var block_array_t=
[
 0,1,0,0,
 1,1,1,0,
 0,0,0,0,
 0,0,0,0,
];

var block_array_z=
[
 1,1,0,0,
 0,1,1,0,
 0,0,0,0,
 0,0,0,0,
];

var block_array_j=
[
 1,0,0,0,
 1,1,1,0,
 0,0,0,0,
 0,0,0,0,
];

var block_array_o=
[
 1,1,0,0,
 1,1,0,0,
 0,0,0,0,
 0,0,0,0,
];

var block_array_l=
[
 0,0,1,0,
 1,1,1,0,
 0,0,0,0,
 0,0,0,0,
];

var block_array_s=
[
 0,1,1,0,
 1,1,0,0,
 0,0,0,0,
 0,0,0,0,
];

var block_type=0;

function spawn_block()
{
 var x,y;
 var p; /*originally *p in C. However, arrays are objects and automatically pointers in JavaScript*/
 
 console.log("spawn_block()");

 if(block_type==0)
 {
  p=block_array_i;
  main_block.color=0x00FFFF;
  main_block.width_used=4;
  main_block.id='I';
 }

 if(block_type==1)
 {
  p=block_array_t;
  main_block.color=0xFF00FF;
  main_block.width_used=3;
  main_block.id='T';
 }

 if(block_type==2)
 {
  p=block_array_z;
  main_block.color=0xFF0000;
  main_block.width_used=3;
  main_block.id='Z';
 }

 if(block_type==3)
 {
  p=block_array_j;
  main_block.color=0x0000FF;
  main_block.width_used=3;
  main_block.id='J';
 }

 if(block_type==4)
 {
  p=block_array_o;
  main_block.color=0xFFFF00;
  main_block.width_used=2;
  main_block.id='O';
 }

 if(block_type==5)
 {
  p=block_array_l;
  main_block.color=0xFF7F00;
  main_block.width_used=3;
  main_block.id='L';
 }

 if(block_type==6)
 {
  p=block_array_s;
  main_block.color=0x00FF00;
  main_block.width_used=3;
  main_block.id='S';
 }

 /*copy another new block array into the current one*/
 y=0;
 while(y<max_block_width)
 {
  x=0;
  while(x<max_block_width)
  {
   main_block.array[x+y*max_block_width]=p[x+y*max_block_width];
   x+=1;
  }
  y+=1;
 }

 main_block.x=Math.floor((grid_width-main_block.width_used)/2);
 main_block.y=0;

 main_block.spawn_x=main_block.x;
 main_block.spawn_y=main_block.y;
 
 console.log("main_block.id=="+main_block.id);
}

/*Part 2: Functions that modify the block data or Tetris grid itself. */

function pixel_on_grid(x,y)
{
 if(x<0){/*printf("Error: Negative X\n");*/return 1;}
 if(y<0){/*printf("Error: Negative Y\n");*/return 1;}
 if(x>=grid_width){/*printf("Error: X too high.\n");*/return 1;}
 if(y>=grid_height){/*printf("Error: Y too high.\n");*/return 1;}
 else{return main_grid.array[x+y*grid_width];}
}





/*
checks whether or not the block collides with anything on the current field
*/
function tetris_check_move()
{
 var x,y;
 moves_tried++; /*move attempted*/
 
  console.log("tetris_check_move();");

 y=0;
 while(y<max_block_width)
 {
  x=0;
  while(x<max_block_width)
  {
   if(main_block.array[x+y*max_block_width]!=0)
   {
    if( pixel_on_grid(main_block.x+x,main_block.y+y)!=0 )
    {
     /*printf("Error: Block in Way on Move Check.\n");*/
          console.log("Error: Block in Way on Move Check.\n");
     return 1; /*return failure*/
    }
   }
    x+=1;
  }
  y+=1;
 }
 
 move_log[moves]=move_id;
 console.log(move_id);
 moves++; /*move successful*/
 return 0;

}







/*I separated the score into its own function to help me not get lost in the line clearing function*/

function tetris_score()
{
 /*scoring section*/
 if(lines_cleared==1)
 {
  if(last_move_spin==1)
  {
   if(back_to_back>0){score+=1200;}
   else{score+=800;}
   back_to_back++;
  }
  else
  {
   score+=100;back_to_back=0;
  }
 }
 if(lines_cleared==2)
 {
  if(last_move_spin==1)
  {
   if(back_to_back>0){score+=1800;}
   else{score+=1200;}
   back_to_back++;
  }
  else
  {
   score+=300;back_to_back=0;
  }
 }
 if(lines_cleared==3)
 {
  if(last_move_spin==1)
  {
   if(back_to_back>0){score+=2400;}
   else{score+=1600;}
   back_to_back++;
  }
  else {score+=500;back_to_back=0;}
 }
 
 if(lines_cleared==4)
 {
  if(back_to_back>0){score+=1200;}
  else{score+=800;}
  back_to_back++;
 }

}






/*clear the lines when they are full*/

function tetris_clear_lines()
{
 var x,y,xcount,x1,y1;

 lines_cleared=0;

 y=grid_height;
 while(y>0)
 {
  y-=1;

  xcount=0;
  x=0;
  while(x<grid_width)
  {
   if(main_grid.array[x+y*grid_width]!=empty_color){xcount++;}
   x+=1;
  }

  /*printf("row %d xcount %d\n",y,xcount);*/

  if(xcount==grid_width)
  {
   y1=y;

   /*printf("row %d line clear attempt.\n",y);*/

   x1=0;
   while(x1<grid_width)
   {
    main_grid.array[x1+y1*grid_width]=empty_color;
    x1++;
   }
   
  
   lines_cleared++;
  }

 }


 lines_cleared_total+=lines_cleared;

 if(lines_cleared!=0){combo++;}
 else{combo=0;}

 /*printf("combo: %d\n",combo);*/

 /*printf("this line clear: %d\n",lines_cleared);*/
 /*printf("total lines cleared: %d\n",lines_cleared_total);*/

 tetris_score();
 

 if(lines_cleared!=0)
 {
  lines_cleared_last=lines_cleared;

 }

}









/*lines fall down to previously cleared line spaces*/

function tetris_fall_lines()
{
 var x,y,xcount,y1;

/* printf("Time to make lines fall\n");*/

 y=grid_height;
 while(y>0)
 {
  y-=1;

  xcount=0;
  x=0;
  while(x<grid_width)
  {
   if(main_grid.array[x+y*grid_width]!=empty_color){xcount++;}
   x+=1;
  }

  /*printf("row %d xcount %d\n",y,xcount);*/

  if(xcount==0)
  {
   /* printf("row %d is empty\n",y);*/

   /*find first non empty row above empty row*/

   y1=y;
   while(y1>0)
   {
    y1--;
    xcount=0;
    x=0;
    while(x<grid_width)
    {
     if(main_grid.array[x+y1*grid_width]!=empty_color){xcount++;}
     x+=1;
    }
    if(xcount>0)
    {
     /*printf("row %d is not empty. Will copy to row %d.\n",y1,y);*/

     x=0;
     while(x<grid_width)
     {
      main_grid.array[x+y*grid_width]=main_grid.array[x+y1*grid_width];
      main_grid.array[x+y1*grid_width]=empty_color;
      x++;
     }
     break;
    }
   }

  }

 }

}








/*this function controls whether or not the block index changes.*/
function tetris_next_block()
{
 if(blocks_used==1){return;} /*do nothing if only one block type used*/
 /*optionally increment block type for different block next time.*/
 block_type++;  block_type%=blocks_used;
 
 console.log("tetris_next_block();");
 console.log("block_type=="+block_type);
}




/*this function is called whenever you press down and then you have reached the bottom. Then the block must stay there before respawning the next one.*/

function tetris_set_block()
{
 var x,y;

 console.log("tetris_set_block()");

  /*draw block onto grid at it's current location*/
  y=0;
  while(y<max_block_width)
  {
   x=0;
   while(x<max_block_width)
   {
    if(main_block.array[x+y*max_block_width]!=0)
    {
     main_color=main_block.color;
     main_grid.array[main_block.x+x+(main_block.y+y)*grid_width]=main_color;
    }
    x+=1;
   }
   y+=1;
  }



 tetris_clear_lines();

 if(lines_cleared_last>0){tetris_fall_lines();}


 tetris_next_block();
 
 spawn_block();


}







/*all things about moving down*/
function tetris_move_down()
{
 console.log("tetris_move_down();");
 /*make backup of block location*/

 //temp_block=main_block;

  ///temp_block.array=Array.from(main_block.array); // fastest way to clone an array in JavaScript
  
  temp_block.y=main_block.y;

  console.log(main_block);

 main_block.y+=1;

 last_move_fail=tetris_check_move();
 console.log("last_move_fail=="+last_move_fail);
 if(last_move_fail)
 {
  ///main_block=temp_block;
  main_block.y=temp_block.y;
  /*printf("Block is finished\n");*/
  tetris_set_block();
  move_log[moves]=move_id;
  moves++; /*moves normally wouldn't be incremented because move check fails but setting a block is actually a valid move.*/
 }
 else
 {
  /*move was successful*/
 }

 last_move_fail=0; /*because moving down is always a valid operation, the fail variable should be set to 0*/
}









/*
 this function is a modification of the move down function to instantly drop a block down.
 in modern tetris games, this is called a hard drop.
*/

function tetris_hard_drop()
{
 var temp_moves=moves;

 last_move_fail=tetris_check_move();
 while(!last_move_fail)
 {
  temp_block.y=main_block.y;
  main_block.y+=1;
  last_move_fail=tetris_check_move();
 }

  main_block.y=temp_block.y;
  /*printf("Block is finished\n");*/
  tetris_set_block();
  moves=temp_moves;
  move_log[moves]=move_id;
  moves++; /*moves normally wouldn't be incremented because move check fails but setting a block is actually a valid move.*/


 last_move_fail=0; /*because moving down is always a valid operation, the fail variable should be set to 0*/
}











/*all things about moving up*/
function tetris_move_up()
{
 temp_block.y=main_block.y;
 main_block.y-=1;
 last_move_fail=tetris_check_move();
 if(!last_move_fail)
 {
  last_move_spin=0;
 }
 else
 {
  main_block.y=temp_block.y;
 }
}








/*all things about moving right*/
function tetris_move_right()
{
 temp_block.x=main_block.x;
 main_block.x+=1;
 last_move_fail=tetris_check_move();
 if(!last_move_fail)
 {
  last_move_spin=0;
 }
 else
 {
  main_block.x=temp_block.x;
 }
}







/*all things about moving left*/
function tetris_move_left()
{
 temp_block.x=main_block.x;
 main_block.x-=1;
 last_move_fail=tetris_check_move();
 if(!last_move_fail)
 {
  last_move_spin=0;
 }
 else
 {
  main_block.x=temp_block.x;
 }
}





/*
fancy right rotation system for T blocks only
does not actually rotate. Rather tries to move a T block into another valid spot and simulate SRS rules
*/
function block_rotate_right_fancy_t()
{
 var x=0,y=0;

 if(main_block.id!='T')
 {
  console.log("Block is not T. No action will be taken.");return;
 }

 x=main_block.x;
 y=main_block.y;


 main_block.x=x-1;
 main_block.y=y+1;
 last_move_fail=tetris_check_move();
 if(last_move_fail)
 {
  /*printf("First fancy T Block spin attempt failed.");*/
  
  main_block.x=x-1;
  main_block.y=y+2;
  last_move_fail=tetris_check_move();
  if(last_move_fail)
  {
   /*printf("Second fancy T Block spin attempt failed.");*/
  }

 }

}





/*basic (non SRS) rotation system*/
function block_rotate_right_basic()
{
 var x=0,y=0,x1=0,y1=0;

 // temp_block=main_block;
 
 temp_block.array=Array.from(main_block.array); // fastest way to clone an array in JavaScript

 /*copy it from top to bottom to right to left(my own genius rotation trick)*/
 /*same as in the left rotation function but x,y and x1,y1 are swapped in the assignment*/

 x1=main_block.width_used;
 y=0;
 while(y<main_block.width_used)
 {
  x1--;
  y1=0;
  x=0;
  while(x<main_block.width_used)
  {
   main_block.array[x1+y1*max_block_width]=temp_block.array[x+y*max_block_width];
   x+=1;
   y1++;
  }
  y+=1;
 }

 /*if rotation caused collision, restore to the backup before rotate.*/
 last_move_fail=tetris_check_move();
 if(last_move_fail)
 {
  /*if basic rotation failed, try fancier*/
  block_rotate_right_fancy_t();
 }
 if(last_move_fail)
 {
  /*if it still failed, revert block to before rotation*/
  main_block.array=Array.from(temp_block.array); // fastest way to clone an array in JavaScript
 }
 else
 {
  last_move_spin=1;
 }

}






















/*
fancy left rotation system for T blocks only
does not actually rotate. Rather tries to move a T block into another valid spot and simulate SRS rules
*/
function block_rotate_left_fancy_t()
{
 var x=0,y=0;

 if(main_block.id!='T')
 {
  console.log("Block is not T. No action will be taken.");return;
 }
 
 x=main_block.x;
 y=main_block.y;


 main_block.x=x+1;
 main_block.y=y+1;
 last_move_fail=tetris_check_move();
 if(last_move_fail)
 {
  /*printf("First fancy T Block spin attempt failed.");*/
  
  main_block.x=x+1;
  main_block.y=y+2;
  last_move_fail=tetris_check_move();
  if(last_move_fail)
  {
   /*printf("Second fancy T Block spin attempt failed.");*/
  }

 }

}


/*basic (non SRS) rotation system*/
function block_rotate_left_basic()
{
 var x=0,y=0,x1=0,y1=0;
//temp_block=main_block;

temp_block.array=Array.from(main_block.array); // fastest way to clone an array in JavaScript

 /*copy it from top to bottom to right to left(my own genius rotation trick)*/
/*same as in the right rotation function but x,y and x1,y1 are swapped in the assignment*/

 x1=main_block.width_used;
 y=0;
 while(y<main_block.width_used)
 {
  x1--;
  y1=0;
  x=0;
  while(x<main_block.width_used)
  {
   main_block.array[x+y*max_block_width]=temp_block.array[x1+y1*max_block_width];
   x+=1;
   y1++;
  }
  y+=1;
 }

 /*if rotation caused collision, restore to the backup before rotate.*/
 last_move_fail=tetris_check_move();
 if(last_move_fail)
 {
  /*if basic rotation failed, try fancier*/
  block_rotate_left_fancy_t();
 }
 if(last_move_fail)
 {
  /*if it still failed, revert block to before rotation*/
  main_block.array=Array.from(temp_block.array); // fastest way to clone an array in JavaScript
 }
 else
 {
  last_move_spin=1;
 }

}










function block_hold()
{
 if(hold_used==0) /*just store block if nothing there*/
 {
  /*printf("hold block used first time.\n");*/
  hold_block={...main_block}; //shallow copy of object
  hold_block.array=Array.from(main_block.array); // clone the array to complete copy
  tetris_next_block();
  spawn_block();
  hold_used=1;
 }
 else
 {
  /*printf("Swap with previous hold block.\n");*/
  temp_block={...hold_block};
  hold_block={...main_block};
  main_block={...temp_block};
  main_block.x=main_block.spawn_x;
  main_block.y=main_block.spawn_y;
 }
 move_log[moves]=move_id; /*hold block is always valid move*/
 moves=moves+1;
}






// Attach the keydown event listener to the document
document.addEventListener('keydown', tetris_keydown );

/* this function handles key events */
function tetris_keydown(event)
{
 // You can access information about the pressed key from the event object
 console.log(`Key pressed: ${event.key}, Key code: ${event.code}`);

 // Example: Move the player based on arrow keys
 const moveAmount = 10;
 switch (event.key)
 {
  case 'ArrowUp':
   tetris_move_up();
  break;
  case 'ArrowDown':
   tetris_move_down();
  break;
  case 'ArrowLeft':
   tetris_move_left();
  break;
  case 'ArrowRight':
   tetris_move_right();
  break;
  
  case 'x':
   block_rotate_right_basic();
  break;
  case 'z':
   block_rotate_left_basic();
  break;
  case 'c':
   block_hold();
  break;
  case ' ':
   tetris_hard_drop();
  break;
 }

 // Redraw the game scene after movement
 javascript_chastetris();
}





























/* this next section must be set apart but is still part of the same file*/








/*sdl_grid_draw.h*/

var block_size;
var grid_offset_x;
var rect={};

function show_grid_fill_rect()
{
 var pixel,r,g,b;
 var x=0,y=0;
 
 console.log("show_grid_fill_rect();");

 y=0;
 while(y<grid_height)
 {
  x=0;
  while(x<grid_width)
  {
   pixel=temp_grid.array[x+y*grid_width];
   r=(pixel&0xFF0000)>>16;
   g=(pixel&0x00FF00)>>8;
   b=(pixel&0x0000FF);


/* printf("x=%d y=%d ",x,y);
 printf("red=%d green=%d blue=%d\n",r,g,b);*/


/*rect_color=SDL_MapRGB(surface->format,r,g,b);*/

 // SDL_SetRenderDrawColor(renderer,r,g,b,255);
 
 //console.log("pixel=="+pixel);
 
  ctx.fillStyle="rgb("+r+","+g+","+b+")";


/*set up the rectangle structure with the needed data to square the squares*/
rect.x=grid_offset_x+x*block_size;
rect.y=y*block_size;
rect.w=block_size;
rect.h=block_size;

// SDL_RenderFillRect(renderer,&rect);

 ctx.fillRect(rect.x,rect.y,rect.w,rect.h);



   x+=1;
  }
  y+=1;
 }
}

var show_grid=show_grid_fill_rect;


































/*
this is a function which is called by main after window is created. This function is basically the game loop.
However, it executes only once and must be called again after user input. It doesn't just run as a loop like a C program would.
*/
function javascript_chastetris()
{
 /*int pixel,r,g,b;*/
 var x=0,y=0;

console.log("javascript_chastetris();");

 /*setup the grid display*/
 block_size=height/grid_height;
 grid_offset_x=(width-(20/2*block_size))/2; /*formula for grid to center of screen*/
 border_size=block_size;

 //printf("block_size==%d\n",block_size);
  
 /*make backup of entire grid*/
  //temp_grid=main_grid;
  
  temp_grid.array=Array.from(main_grid.array); // fastest way to clone an array in JavaScript

  /*draw block onto temp grid at it's current location*/
  y=0;
  while(y<max_block_width)
  {
   x=0;
   while(x<max_block_width)
   {
    if(main_block.array[x+y*max_block_width]!=0)
    {
     if(temp_grid.array[main_block.x+x+(main_block.y+y)*grid_width]!=0)
     {
      //printf("Error: Block in Way\n");
      
      console.log("Error: Block in Way\n");

      /*because a collision has occurred. We will restore everything back to the way it was before block was moved.*/

      break;
     }
     else
     {
      main_color=main_block.color;
      /*main_color=chaste_palette[block_color_index[block_type]];*/
      temp_grid.array[main_block.x+x+(main_block.y+y)*grid_width]=main_color;
     }
    }
    x+=1;
   }
   y+=1;
  }



/*display the tetris grid*/
show_grid();

 /*draw the boundary walls*/

/*
 set up the rectangle structure with the needed data to square the walls
*/

 ///SDL_SetRenderDrawColor(renderer,128,128,128,255);
 
 ctx.fillStyle="rgb("+128+","+128+","+128+")";

 rect.x=grid_offset_x-border_size;
 rect.y=0*block_size;
 rect.w=border_size;
 rect.h=height;

 ///SDL_RenderFillRect(renderer,&rect);
 ctx.fillRect(rect.x,rect.y,rect.w,rect.h);

 rect.x=grid_offset_x+grid_width*block_size;
 ///SDL_RenderFillRect(renderer,&rect);

 ctx.fillRect(rect.x,rect.y,rect.w,rect.h);

 /*end of drawing code for grid*/


}


