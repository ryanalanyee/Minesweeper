import de.bezier.guido.*;
private int NUM_ROWS = 8;
private int NUM_COLS = 8;
private int NUM_MINES = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    //initializes the empty indexes
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    mines = new ArrayList<MSButton>();
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //put something in the indexes
    for(int i = 0; i < NUM_COLS; i++){
      for(int j = 0; j < NUM_ROWS; j++){
         buttons[j][i] = new MSButton(j,i);
      }
    }
    
    
    
    setMines();
}
public void setMines()
{
  while(mines.size() < NUM_MINES)
    {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[r][c]))
    {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true){
        displayWinningMessage();
    }
}
public boolean isWon()
{
    int count = 0;
    for(int i = 0; i < mines.size(); i++){
      if(mines.get(i).isFlagged())
        count++;
    }
    if(count == NUM_MINES)
      return true;
    return false;
}
public void displayLosingMessage()
{
    buttons[1][1].setLabel("you lose ");
    for(int r = 0; r < buttons.length; r++){
      for(int c = 0; c < buttons[r].length; c++){
        if(mines.contains(buttons[r][c]))
          buttons[r][c].clicked = true;
      }
    }
}
public void displayWinningMessage()
{
    buttons[1][1].setLabel("WINNER WINNER CHICKEN DINNER");
}
public boolean isValid(int r, int c)
{
  if(r >= NUM_ROWS || c >= NUM_COLS)
    return false;
  if(r <= -1 || c <= -1)
    return false;
  return true;
}
public int countMines(int row, int col)
{
  int count = 0;
   for(int r = row-1;r<=row+1;r++){
    for(int c = col-1; c<=col+1;c++){
      for(int k = 0; k < mines.size(); k++){
      if(isValid(r,c) && buttons[r][c]==mines.get(k) && buttons[r][c] != buttons[row][col])
        count++;
      }
    }
   }
      return count;
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
        clicked = true;
        if(mouseButton == RIGHT)
        {
          flagged = !flagged;
          if(flagged == false)
            clicked = false;
        } else if(mines.contains(this))
            displayLosingMessage();
          else if(countMines(myRow, myCol) > 0)
            setLabel(countMines(myRow, myCol));
          else {
              for(int r = myRow-1;r<=myRow+1;r++){
                for(int c = myCol-1; c<=myCol+1;c++){
                  if(isValid(r,c) && buttons[r][c].clicked == false && buttons[r][c] != buttons[myRow][myCol])
                     buttons[r][c].mousePressed();
                  }
                }
               
          }
          
          
            
    }
    public void draw () {    
    if (flagged)
        fill(255, 0, 0); // Red for flagged blocks
    else if (clicked && mines.contains(this)) 
        fill((int)(Math.random()*256), (int)(Math.random()*256), (int)(Math.random()*256)); // Random color for clicked bombs
    else if (clicked)
        fill(225);
    else 
        fill(100);
    
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x + width / 2, y + height / 2);
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
