package com.emote.dashboard.emotion_distribution
{
import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.geom.Matrix;

import mx.charts.AxisLabel;
import mx.containers.Box;
import mx.controls.Label;
import mx.core.IDataRenderer;

public class AdvancedAxisRenderer extends Box implements IDataRenderer
{
	
	public function AdvancedAxisRenderer():void
	{
		super();
		this.minHeight = 50;
		this.minWidth = 100;
	}

	private var _axisLabel: AxisLabel;
	private var _label: Label;
	private var columnColor: Number = 0x00FF00;
	
	override protected function createChildren():void {
		super.createChildren();
		if(_label == null){
			_label = new Label();
			_label.selectable = false;
			addChild(_label);
		}
		
	}

	private function redrawBackground(bk_width:Number, bk_height:Number): void {

		var type:String = GradientType.LINEAR;
		var colors:Array = [0x000000, columnColor];
		var alphas:Array = [0, .3];
		var ratios:Array = [0, 250];
		var spreadMethod:String = SpreadMethod.PAD;
		var interp:String = InterpolationMethod.LINEAR_RGB;
		var focalPtRatio:Number = 1;
		
		var matrix:Matrix = new Matrix();
		var boxWidth:Number = bk_width;
		var boxHeight:Number = bk_height;
		var boxRotation:Number = 0;
		var tx:Number = 0;
		var ty:Number = 50;
		matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);

		graphics.beginGradientFill(type, 
		                            colors,
		                            alphas,
		                            ratios, 
		                            matrix, 
		                            spreadMethod, 
		                            interp, 
		                            focalPtRatio);
		graphics.drawRect(0, 0, boxWidth, boxHeight);
		graphics.endFill();

	}
	
	public override function get data():Object
	{	
		return _axisLabel;
	}

	public override function set data(value:Object):void
	{
		if (_axisLabel == value) return;

		_axisLabel = AxisLabel(value);

		if(_axisLabel != null){
			var bz:Array = _axisLabel.text.split('||');
			columnColor = bz[1];
			_label.text = bz[0];
  		}
  		
	}

	override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		if(this.data!=null) redrawBackground(unscaledWidth,unscaledHeight);
	}
}
}