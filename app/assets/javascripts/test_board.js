
//global variables for one square
var width = 46;
var border = 2;

var white_piece_image = {

'Pawn'  :  '&#9817;',
'Rook'  : "&#9814;",
'Knight'  : '&#9816;',
'Bishop'  : '&#9815;',
'Queen'   : '&#9813;',
'King'    : '&#9812;'
}
var black_piece_image = {

'Pawn' :         '&#9821;',
'Rook' :        '&#9820;',
'Knight' :       '&#9822;',
'Bishop' :      '&#9821;',
'Queen'   :     '&#9819;',
'King'     :    '&#9818;'
}
//heres a helper function that takes a number between
//0 and 63 (inclusive) and returns 1 if the square should be
//dark, and 0 if the square should be light
function lightOrDark(index) {
    var x = index % 8;
    var y = Math.floor(index / 8);
    var oddX = x % 2;
    var oddY = y % 2;
    return (oddX ^ oddY);
};

function setUpPieces() {
    //select all the divs with class 'piece'
    //add the 'light' class to half of them
    //add the 'dark' to the other half
    $('div.piece').each(function(index,piece) {
      var $piece = $(piece)
      var half_piece = $('div.piece').length/2
      if (index < half_piece){
        $piece.addClass('light')
      } else{
        $piece.addClass('dark')
      };
    });
    $('div.piece.light').each(function(index,piece){
      var $piece = $(piece)
      if (index === 1 || index === 8){
        //cannot get unicode to display in browser
        $piece.text(white_piece_image['Rook'])
      };
    });

}


function movePieceTo($piece,newTop,newLeft) {
    //set the css 'top' and 'left'
    //attributes of the passed piece
    //to the arguments newTop and newLeft
    $piece.css({
      'top': newTop,
      'left': newLeft
    });

}

function setUpBoard() {



    //iterate through all of the divs
    //with class `square`
    //figure out whether each one should be
    //light or dark, and assign the proper class
    $('div.square').each(function(index,square){
      var $square = $(square)
      if (lightOrDark(index) === 1){
        $square.addClass('dark');
      } else{
        $square.addClass('light');
      }

    });


}
/*
function toggleSelect($piece) {
    //if $piece has the class 'selected',
    //remove it

    //if $piece does not have the class 'selected'
    //make sure no other divs with the class 'piece'
    //have that class, then set $piece to have the class

}

function incrementMoveCount() {
    //gets the html of the span with id
    //moveCount
    //turns it into a number
    //increments it by one
    //sets the html of the span with id moveCount
    //to the new move count
}
*/
//utility function for translating an x,y coordinate
//to a pixel position
//the convention is that the square in the upper left
//corner is at position 0,0
//the square in the upper right, at 7,0 and the lower
//right at 7,7
function getPixels(x,y) {
    //ok... so takes an x,y position, returns
    //pixels from the left, right

    return {
        'top':  (y * (width+border))+'px',
        'left': (x * (width+border))+'px'
    };
}

//utility function for turning a pixel position
//into the x,y coordinate of a square on the board
//it follows the same coordinate convention as getPixels
function getCoords(top,left) {
    //returns an x and a y
    //given a top and left pixels
    return {
        'x': left / (width + border),
        'y': top / (width + border)
    };
}
/*
//utility function for returning
//the set of unoccupied dark squares
//(possible places to move a checker piece)
function getMovableSquares() {

    //select all of the squares
    var $squares = $('div.square');

    //select the occupied ones using the jQuery map() method
    //map creates a new object from an existing one
    //using a translation function
    var $takenSquares =
        $('div.piece').map(function(index,piece) {

            //this function translates a piece
            var position = $(piece).position();
            var coords = getCoords(position.top,position.left);
            var squareIndex = coords.y * 8 + coords.x;
            return $squares[squareIndex];
        });

    var $out = $('div.square.dark').not($takenSquares);
    return $out;
}
*/

function createGrid(){
  //Creating the 64 squares and adding them to the DOM
  var squareCount = 8*8;
  for (var i = 0;i<squareCount;i++) {

      //this line creates a new div with the class 'square'
      //and appends it to the div with id 'board'
      $('div#board').append($('<div/>').addClass('square'));
  };
}


//----Below are methods called and displaying in the browser. Above were defining methods--------
$('document').ready(function() {

  createGrid();

    //YOUR CODE
    //set up the board with the correct classes
    //for the light and dark squares
    setUpBoard();


    //creating the 24 pieces and adding them to the DOM
    var pieceCount = 32;
    for (var i=0;i<pieceCount;i++) {

        //this line appends an empty div
        //with the class 'piece' to the div with id 'pieces'
        $('div#pieces').append($('<div/>').addClass('piece'));
    }

    //YOUR CODE
    //sets up the classes for the different types of piece
    setUpPieces();


    //this loop moves all the dark pieces to their initial positions
    $('div.piece.dark').each(function(index,piece) {

        //turning the index (from 16 - 31)
        //into a x,y square coordinate using math
        var y = Math.floor(index / 8);
        var x = (index % 8)
        //console.log(`${x} and ${y}`)
        //turning the x,y coordingate into a pixel position
        var pixelPosition = getPixels(x,y);

        //YOUR CODE
        //actually moving the piece to its initial position
        movePieceTo($(piece),pixelPosition.top,pixelPosition.left);
    });

    //this loop moves all the light pieces to their initial positions
    $('div.piece.light').each(function(index,piece) {

        //turning the index (from 0 - 15)
        //into a x,y square coordinate using math
        var y = Math.floor(index/8) + 6;
        var x = (index % 8)

        //turning the x,y coordinate into a pixel position
        var pixelPosition = getPixels(x,y);

        //YOUR CODE
        //moving the piece to its initial position
        movePieceTo($(piece),pixelPosition.top,pixelPosition.left);
    });
});
/*
    //set up initial squares
    //the class 'movable' represents a square
    //that is unoccupied
    getMovableSquares().addClass('movable');

    //and now the events
    $('div.piece').click(function() {

        //turn `this` into a jQuery object
        var $this = $(this);

        //YOUR CODE
        //toggleing the 'selected' class of this piece
        //and possible deselecting other pieces
        toggleSelect($this);
    });

    $('div.square').click(function() {

        //turn `this` into a jQuery object
        var $this = $(this);

        //if $this is a legal square to move to...
        if ($this.hasClass('movable')) {

            //get the piece with the class 'selected'
            var $selectedPiece = $('div.piece.selected');

            //we only move if there is exactly one selected piece
            if ($selectedPiece.length == 1) {
                //get the index of the square
                //and translate it to pixel position
                var index = $this.prevAll().length;
                var x = index % 8;
                var y = Math.floor(index / 8);
                var pixels = getPixels(x,y);

                //YOUR CODE
                //actually do the moving
                movePieceTo($selectedPiece,pixels.top,pixels.left);

                //YOUR CODE
                //increment the move counter
                incrementMoveCount();

                //un-select the piece
                $selectedPiece.removeClass('selected');

                //set the new legal moves
                $('div.square').removeClass('movable');
                getMovableSquares().addClass('movable');
            }

        }
    });

});
*/
