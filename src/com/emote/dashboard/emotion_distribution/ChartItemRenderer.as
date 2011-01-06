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
		[Embed(source='assets/fonts/MyriadPro-Bold.otf', fontName="MyriadProE", fontWeight="bold", mimeType="application/x-font-truetype")]
		private var font1:Class;

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
		        label.setStyle("fontSize", 13);	      
		        label.setStyle("textAlign", "center");
		        label.setStyle("fontFamily", "MyriadProE");
		        label.setStyle("fontWeight", "bold");
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
	       	if (barHeight < labelHeight+14) // if no room for label
	       	{
				// nudge label up the amount of pixels missing
	       		label.y = -1 * (labelHeight - barHeight);
	       		//labelColor = 0x222222; // label will appear on white background, so make it dark	       		
	       	}
	       	else
			{	
				// center the label vertically in the bar
	       		label.y =  14;
			}
			
			label.setStyle("color", labelColor);
	       	
	        var columnColor:uint = csi.item['color'];
	        var tr:Number = ((csi.element as ColumnSeries).selectedItem == csi) ? 0.7 : .88;
	        
	        var fType:String = GradientType.LINEAR;
			var colors:Array = [ 0xffffff, 0xffffff, columnColor, columnColor ];
			var alphas:Array = [ 1, tr, tr, tr ];
			var r1:Number = 4/csi.min*255;
			var r2:Number = 16/csi.min*255;
			var ratios:Array = [ 0, r1, r2, 255 ];
			var matr:Matrix = new Matrix();
    		matr.createGradientBox( width, csi.min, Math.PI/2, 0, 0 );
			//SpreadMethod will define how the gradient is spread. Note!!! Flash uses CONSTANTS to represent String literals
			var sprMethod:String = SpreadMethod.REFLECT;
    		g.beginGradientFill( fType, colors, alphas, ratios, matr, sprMethod );
	        
			// Draw the column
			//g.beginFill(columnColor, tr); // bitmapFill
			g.drawRoundRect(rc.left, rc.top, rc.width, rc.height+8, 18, 18);
			
			this.back.graphics.clear();
			this.back.graphics.beginFill(columnColor, .2);
			this.back.graphics.drawRoundRect(0, 20, rc.width, -csi.min-20, 0, 0);
	        /*g.lineTo(rc.right,rc.top);
	        g.lineTo(rc.right,rc.bottom);
	        g.lineTo(rc.left,rc.bottom);
	        g.lineTo(rc.left,rc.top);*/
	        g.endFill();
  		}
	}
}