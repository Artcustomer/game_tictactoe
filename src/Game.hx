package;
import js.Browser;
import js.html.DivElement;
import js.html.Element;

/**
 * ...
 * @author David Massenot
 */
class Game
{
	private var _container:DivElement;
	private var _gridContainer:DivElement;
	private var _numRows:Int = 3;
	private var _tileSize:Int = 100;
	private var _tilesStates:Array<Array<String>> = [['_', '_', '_'], ['_', '_', '_'], ['_', '_', '_']];
	private var _players:Array<String> = ['X', 'O'];
	private var _currentPlayer = 0;

	public function new() 
	{
		Browser.document.addEventListener("DOMContentLoaded", function(event) {
			init();
			drawGrid();
		});
	}
	
	private function init() {
		_container = Browser.document.createDivElement();
		_container.className = 'game-container';
		
		Browser.document.querySelector(".container").appendChild(_container);
	}
	
	private function drawGrid()
	{
		_gridContainer = Browser.document.createDivElement();
		_gridContainer.className = 'grid-container';
		_container.appendChild(_gridContainer);
		
		for (i in 0..._numRows) {
			for (j in 0..._numRows) {
				var tile = drawTile(i, j);
				
				_gridContainer.appendChild(tile);
			}
		}
	}
	
	private function drawTile(xPos:Int, yPos:Int) {
		var tile = Browser.document.createDivElement();
		tile.className = 'tile tile-available';
		tile.style.marginLeft = (xPos * _tileSize) + 'px';
		tile.style.marginTop = (yPos * _tileSize) + 'px';
		tile.innerText = '';
		tile.dataset.x = Std.string(xPos);
		tile.dataset.y = Std.string(yPos);
		
		if (_numRows - 1 > yPos) {
			tile.style.borderBottom = '1px solid black';
		}
		
		if (_numRows - 1 > xPos) {
			tile.style.borderRight = '1px solid black';
		}
		
		tile.onmouseover = function(e) {
			tile.textContent = _players[_currentPlayer];
		}
		
		tile.onmouseleave = function(e) {
			tile.textContent = '';
		}
		
		tile.onclick = function(e) {
			lockTile(tile);
			storeState(xPos, yPos, _players[_currentPlayer]);
			
			var result = checkStates();
			
			if (null == result) {
				switchPlayer();
			} else {
				endGame();
			}
			
		};
		
		return tile;
	}
	
	private function lockTile(tile:Element) {
		tile.onmouseover = null;
		tile.onmouseleave = null;
		tile.onclick = null;
		tile.className = 'tile';
	}
	
	private function switchPlayer() {
		++_currentPlayer;
		
		if (_currentPlayer >= _players.length) {
			_currentPlayer = 0;
		}
	}
	
	private function endGame() {
		for (i in 0..._gridContainer.childElementCount) {
			var tile:Element = _gridContainer.children[i];
			
			lockTile(tile);
		}
		
		Browser.alert('Player ' + _players[_currentPlayer] + ' win !');
	}
	
	private function storeState(x:Int, y:Int, value:String) {
		_tilesStates[x][y] = value;
	}
	
	private function checkStates() {
		if (checkPlayerWon()) {
			return _players[_currentPlayer];
		}
		
		return null;
	}
	
	private function checkPlayerWon() {
		var model = 'A...A...A|A..A..A|A.A.A|AAA';
		var pattern = StringTools.replace(model, 'A', _players[_currentPlayer]);
		
		return new EReg(pattern, '').match(joinState());
	}
	
	private function joinState() {
		return _tilesStates.map(function (a) return a.join('')).join('');
	}
}