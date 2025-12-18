# Hacking Minecraft Java Edition with chastehex

The save files on my Linux machine are here:

/home/chastity/.minecraft/saves/

I decided to see if my chastehex program would be any use at editing save files of Minecraft.

The first step is to use chastecmp (another program I wrote) to compare two files of slight differences.

The first target was the level.dat file. I had created a new world, collected 3 oak logs from a tree, and saved.

Debian Linux detected that the level.dat file was actually a gzip archive. Therefore, to get the true data, these commands are required. The first copies it so that it has a ".gz" extension. The second decompresses it.

```
cp level.dat file0.gz
gzip -d file0.gz
````

Now there is a file named file0 which has the raw data uncompressed. The next step is to load up the game, make a small change and then resave the file. I threw away one oak log so that I had 2 instead of 3. Then I saved the game and ran these commands to get the uncompressed data for the second file.

```
cp level.dat file1.gz
gzip -d file1.gz
````

I compared the two files with chastecmp:

`chastecmp file0 file1`

And the result was:

```
file0 Opened OK
file1 Opened OK
00000052 48 CF 
000003E9 48 CF 
000007FE 48 CF 
000009F0 03 02 
000011D2 69 68 
000011D3 0E 87 
000011E5 FB 74 
0000124B 72 81 
0000124C EE C7 
0000124D 99 BA 
file0 has reached EOF
```

It appears that address 9F0 contains the amount of oak logs in the first item slot in the game.

I ran this command to change that byte to 20 hex/32 decimal

`chastehex file0 9F0 20`

The next step is to recompress the data into a level.dat file that the game expects to load.

```
gzip -k file0
cp file0.gz level.dat
```
Amazingly, when I loaded the game, I did in fact have 32 oak logs. Obviously this process requires multiple steps and is painfully slow, however it proves that my command line tools can hack Minecraft because there is compression but no encryption in the files.

The level.dat file seems to contain the player's inventory and other important data. I remember this from experiments with it years ago.

## Warning

The addresses and what they mean can change wildly as new data is added to the file. For example, I found a village and there were 5 iron ingots in a chest. I repeated the steps above to create two uncompressed files.

The difference between the files in this case were that I threw 3 of the ingots on the ground and so the number had changed from 5 to 2 in the `chastecmp file0 file1` output

`00000F5F 05 02 `

So then I ran the command to change the count to 64 (40 hex)

`chastehex file0 F5F 40`

Upon recompressing the file and putting it back in the game folder, I did have 64 ingots. I had previously tried numbers higher than 64 but unfortunately the results were not good. I ended up with only one ingot instead. Therefore, it is good to stick within the limits of what the game expects for the cheating to be successful.

But because the addresses change as new data gets added to the game, cheating by hex editing is painfully slow on Minecraft. This is best done on a brand new world, both because the data is small and also so that you don't corrupt worlds you have been playing on longer.

But I did it as a proof of concept just to see if the programs I wrote can be used to hack Minecraft. The answer is yes, with a little help from gzip for decompression and recompression.

But what if I told you there was an easier way to cheat at Minecraft Java Edition? You see, the secret still lies with the level.dat file. You don't actually need to use chastehex, chastecmp, or compression. This is because the file contains the player inventory but not the items they have stored in chests in the world! This allows for item duplication.

So place the items you want to duplicate in your inventory. Then save the game and backup the file.

`cp level.dat backup.dat`

Then place those items in a chest then save again. Restore the file you backed up earlier.

`cp backup.dat level.dat `

When you reload the game, the files will still be in the chest but your player will also be holding them. This means you can infinitely duplicate any item you can obtain in the game normally by just copying save files repeatedly.

Why then, did I go through the process of showing how to cheat with chastehex? Because the point is not so much about hacking the game, or what the game is, but it is about testing the programs I wrote. I care more about my C and Assembly programming skills than I do the outcome of a game.

The point is not whether you win or lose the game. The point is that the game was made by humans and can be broken by humans. Sometimes, as in Castle of the Winds or Cave Story, hacking with a hex editor is the most reliable method. In a game like Minecraft, sometimes cheating is easier because of player and world data being in completely separate files.