/*
This file is for the handling of multiple game states for Chaste Tris
*/

int save_index=0;

/*a big structure to hold all relevant data that should be saved or loaded*/
struct gamesave
{
 int exist;
 int moves;

 int score;

 int combo;

 struct tetris_block main_block; /* to save the main and hold blocks */
 struct tetris_grid grid;

 struct panel_player player;
};

struct gamesave state[10];


/*
 a special function which saves all the important data in the game. This allows reloading to a previous position when I make a mistake.
*/
void save_gamesave()
{
 state[save_index].player=player;
 state[save_index].grid=main_grid;

 state[save_index].main_block=main_block;

 state[save_index].moves=moves;

 state[save_index].score=score;

 state[save_index].combo=combo;

 printf("State %d saved\n",save_index);
 
 state[save_index].exist=1;
}

/*
 a special function which loads the data previously saved. This allows reloading to a previous position when I make a mistake.
*/
void load_gamesave()
{
 if(!state[save_index].exist)
 {
  printf("State %d has not be saved yet! Nothing to load!\n",save_index);
  return;
 }
 
 player=state[save_index].player;

 main_grid=state[save_index].grid;

 main_block=state[save_index].main_block;

 moves=state[save_index].moves;

 score=state[save_index].score;

 combo=state[save_index].combo;

 printf("State %d loaded\n",save_index);
}

