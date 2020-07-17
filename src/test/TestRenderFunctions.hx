package test;

import roguelike.RenderFunctions.splitLinesWords;
import roguelike.RenderFunctions.wrapWordGrid;

using buddy.Should;

@:access(roguelike.RenderFunctions)
class TestRenderFunctions extends buddy.BuddySuite {
	
	public function new() {
		
		describe( "Test splitLinesWords", {

			it( "splitLinesWords Hello", {
				final wordGrid = splitLinesWords( "Hello" );
				wordGrid.length.should.be( 1 );
				wordGrid[0].length.should.be( 1 );
			});

			it( "splitLinesWords Hello World", {
				final wordGrid = splitLinesWords( "Hello World!" );
				wordGrid.length.should.be( 1 );
				wordGrid[0].length.should.be( 2 );
			});

			it( "splitLinesWords Hello\\nWorld", {
				final wordGrid = splitLinesWords( "Hello\nWorld!" );
				wordGrid.length.should.be( 2 );
				wordGrid[0].length.should.be( 1 );
				wordGrid[1].length.should.be( 1 );
			});

		});
		
		describe( "Test wrapWordGrid", {

			it( "wrapWordGrid 1", {
				final wordGrid = splitLinesWords( "Press the key next to an item to use it, or Esc to cancel." );
				final wrappedLines = wrapWordGrid( wordGrid, 50 );
				wrappedLines.length.should.be( 2 );
			});

			it( "wrapWordGrid 2", {
				final wordGrid = splitLinesWords( "Press the key next to an item to use it, or Esc to cancel.\n" );
				final wrappedLines = wrapWordGrid( wordGrid, 50 );
				wrappedLines.length.should.be( 3 );
			});

		});
	}

}