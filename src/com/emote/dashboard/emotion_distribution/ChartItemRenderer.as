package com.emote.dashboard.emotion_distribution
{	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.charts.ChartItem;
	import mx.charts.chartClasses.LegendData;
	import mx.charts.series.ColumnSeries;
	import mx.charts.series.items.ColumnSeriesItem;
	import mx.controls.Label;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	public class ChartItemRenderer extends UIComponent implements IDataRenderer
	{
		private var label:Label;
		private var back:Sprite;
		private var _chartItem:ChartItem; // stores current ColumnSeriesItem
		[Embed(source='assets/gayish_heading.png')]
		private var head:Class;

	    public function ChartItemRenderer():void
	    {
	        super();	        
	    }

		override protected function createChildren():void
		{	
			if (back == null)
	        {
				// create and add the back
		        back = new Sprite();
		        addChild(back);
		        this.setChildIndex(back, 0);
	        }
	        
			super.createChildren();
			
			if (label == null)
	        {
				// create and add the label
		        label = new Label();
		        label.truncateToFit = true;	
		        label.setStyle("fontSize", 12);	      
		        label.setStyle("textAlign", "center");
		        addChild(label);
	        }
	        	        
		}
				
		public function set data(value:Object):void
	    {
	        if (_chartItem == value) return;
	          // setData also is executed if there is a Legend Data 
	          // defined for the chart. We validate that only chartItems are 
	          // assigned to the chartItem class. 
	        if (value is LegendData) 
	        	return;
			
	        _chartItem = ChartItem(value);	        
	    }	
		
	    public function get data():Object
	    {
	        return _chartItem;
	    }
                                         
    	override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
  		{
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	        
	        var rc:Rectangle = new Rectangle(0, 0, width, height);	       
	        var g:Graphics = graphics;
	        g.clear();        
	        g.moveTo(rc.left, rc.top);
	         
	        if (_chartItem == null) // _chartItem has no data
	           return;
	           
	        var cs:ColumnSeries = _chartItem.element as ColumnSeries;
	        var csi:ColumnSeriesItem = _chartItem as ColumnSeriesItem;
			
	       	// set the label			       	
       		label.text = csi.item[cs.yField].toString();
	       	label.width = label.maxWidth = unscaledWidth;	       	
	       	label.height = label.textHeight;
			var labelHeight:int = label.textHeight + 2;
				       		        	 
	        // label's default y is 0. if the bar is too short we need to move it up a bit
	       	var barYpos:Number = csi.y;
	       	var minYpos:Number = csi.min;
			var barHeight:Number = minYpos - barYpos;
			var labelColor:uint = 0xFFFFFF; // white
			//back.y = -minYpos;
			//this.addChild(hh);
	       	if (barHeight < labelHeight) // if no room for label
	       	{
				// nudge label up the amount of pixels missing
	       		label.y = -1 * (labelHeight - barHeight);
	       		labelColor = 0x222222; // label will appear on white background, so make it dark	       		
	       	}
	       	else
			{	
				// center the label vertically in the bar
	       		label.y = barHeight / 2 - labelHeight / 2;
			}
			
			label.setStyle("color", labelColor);
	       	
	        var columnColor:uint = csi.item['color'];
	        
	        /*var fType:String = GradientType.LINEAR;
			//Colors of our gradient in the form of an array
			var colors:Array = [ 0xF1F1F1, 0x000000 ];
			//Store the Alpha Values in the form of an array
			var alphas:Array = [ 1, 1 ];
			//Array of color distribution ratios.  
			//The value defines percentage of the width where the color is sampled at 100%
			var ratios:Array = [ 0, 4 ];
			//Create a Matrix instance and assign the Gradient Box
			var matr:Matrix = new Matrix();
    		matr.createGradientBox( width, height, Math.PI, 0, 0 );
			//SpreadMethod will define how the gradient is spread. Note!!! Flash uses CONSTANTS to represent String literals
			var sprMethod:String = SpreadMethod.PAD;
			//Start the Gradietn and pass our variables to it
			
    		g.beginGradientFill( fType, colors, alphas, ratios, matr, sprMethod );*/
	        
			// Draw the column
			g.beginFill(columnColor, 0.9); // bitmapFill
			g.drawRoundRect(rc.left, rc.top, rc.width, rc.height, 8, 8);
	        /*g.lineTo(rc.right,rc.top);
	        g.lineTo(rc.right,rc.bottom);
	        g.lineTo(rc.left,rc.bottom);
	        g.lineTo(rc.left,rc.top);*/
	        g.endFill();
  		}
	}
}