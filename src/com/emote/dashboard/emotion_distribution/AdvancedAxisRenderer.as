package com.emote.dashboard.emotion_distribution
{
import flash.display.Graphics;
import flash.geom.Rectangle;

import mx.charts.AxisLabel;
import mx.charts.ChartItem;
import mx.containers.Panel;
import mx.controls.Label;
import mx.core.IDataRenderer;
import mx.core.UIComponent;

public class AdvancedAxisRenderer extends UIComponent implements IDataRenderer
{
	private var _label:Label;
	
	[Embed(systemFont='Arial', fontName='myPlainFont',  mimeType='application/x-font' )]
	private var font1:Class;
	
	public function AdvancedAxisRenderer():void
	{
		super();
		_label = new Label();
		addChild(_label);
		_label.setStyle("color",0x000000);
		_label.setStyle("fontFamily" ,"myPlainFont") ;		
	}
	private var _chartItem:ChartItem;
	private var _axisLabel: AxisLabel;

	public function get data():Object
	{
		return _axisLabel; //_chartItem;
	}

	public function set data(value:Object):void
	{
		//if (_chartItem == value)
		if (_axisLabel == value)
			return;
		//_chartItem = ChartItem(value);
		_axisLabel = AxisLabel(value);

		//if(_chartItem != null)
   		//_label.text = ColumnSeriesItem(_chartItem).item.label[0].toString() + "%";
		if(_axisLabel != null){
   			_label.rotation = 90;
   			_label.text = _axisLabel.text + "%";
   			
   			_axisLabel.value = '';
  		}
	}

	private static const fills:Array = [0xFF0000,0x00FF00,0x0000FF,
										0x00FFFF,0xFF00FF,0xFFFF00,
										0xAAFFAA,0xFFAAAA,0xAAAAFF];	 
	override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
				
		var fill:Number = 0xA5BC4E;
		
		
		var rc:Rectangle = new Rectangle(0, 0, width , height );
		
		var g:Graphics = graphics;
		g.clear();		
		g.moveTo(rc.left,rc.top);
		g.beginFill(fill);
		g.lineTo(rc.right,rc.top);
		g.lineTo(rc.right,rc.bottom);
		g.lineTo(rc.left,rc.bottom);
		g.lineTo(rc.left,rc.top);
		g.endFill();
		
		_label.setActualSize(_label.getExplicitOrMeasuredWidth(),_label.getExplicitOrMeasuredHeight());
		_label.move(unscaledWidth/2 - _label.getExplicitOrMeasuredWidth()/2,
				rc.top - _label.getExplicitOrMeasuredHeight() - 5);
	}

}
}