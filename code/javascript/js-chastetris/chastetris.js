/* a port of Chaste Tris originally written in C. */

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

var main_grid,temp_grid;

main_grid={}; //empty object
main_grid.array=[]; //empty array

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

