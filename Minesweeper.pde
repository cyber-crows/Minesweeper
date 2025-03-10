import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS=20;
int NUM_COLS=20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
//private ArrayList <MSButton> bombs;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0;r<NUM_ROWS;r++){
      for(int c=0;c<NUM_COLS;c++){
        buttons[r][c]= new MSButton(r,c);
      }
    }
    
    mines = new ArrayList<MSButton>();
    
    setMines();
}
public void setMines()
{
  int mineCount=0;
  int row, col;
  while(mineCount < NUM_ROWS + NUM_COLS){
    row=(int)(Math.random()*NUM_ROWS);
    col=(int)(Math.random()*NUM_COLS); 
    if(!mines.contains(buttons[row][col])){
      mines.add(buttons[row][col]);
      mineCount++;
    }
    }
      
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
   for(int r=0;r<NUM_ROWS;r++){
   for(int c=0;c<NUM_COLS;c++){
     MSButton button= buttons[r][c];
   if(!mines.contains(button) && !button.clicked)
     return false; 
   }
   }
    return true;
}
public void displayLosingMessage()
{
 for (MSButton mine : mines) {  //FOR EACH LOOP instead of going through the indexes it goes through the actual items themselves
        mine.setLabel("M");  
        mine.clicked = true;
    }
 for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c])) {
                buttons[r][c].setLabel("X");  // Mark non-mines with 'X'
            }
        }
    }
}
public void displayWinningMessage()
{
    for(int r=0;r<NUM_ROWS;r++){     
    for(int c=0; c<NUM_COLS; c++){
      buttons[r][c].setLabel("W");
    }
}
}
public boolean isValid(int r, int c)
{
 if(c<NUM_COLS && r<NUM_ROWS && c>=0 && r>=0)
    return true;     
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    int[][] directions = {
        {-1, -1}, {-1, 0}, {-1, 1}, 
        {0, -1},         {0, 1}, 
        {1, -1}, {1, 0}, {1, 1}
    };

    for (int[] dir : directions) {
        int newRow = row + dir[0];
        int newCol = col + dir[1];

        if (isValid(newRow, newCol) && mines.contains(buttons[newRow][newCol])) {
            numMines++;
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      int numMines =countMines(myRow,myCol);
        clicked = true;
        if(mouseButton==RIGHT){
          if(flagged==true)
            flagged=false;
          else
            flagged=true;
        }
        else if(mines.contains(this))
          displayLosingMessage();
        else if(numMines > 0)
          setLabel(numMines);
        else 
          for(int r = -1; r <=1; r++){
          for(int c = -1; c <=1; c++){
           int newRow = myRow + r;
           int newCol = myCol + c;
           if(isValid(newRow,newCol)){
            MSButton a = buttons[newRow][newCol];
            if(!a.clicked && !a.flagged){
             a.mousePressed(); //recursivley reveal
            }
           }
          }
         }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
