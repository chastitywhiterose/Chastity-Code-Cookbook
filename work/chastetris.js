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
grid_width=10,grid_height=20;


