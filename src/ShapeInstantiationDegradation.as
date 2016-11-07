package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.display.Shape;
	
	public class ShapeInstantiationDegradation extends Sprite
	{
		public static const RUNS:int = 11;
		public static const INVOCATIONS_PER_FRAME:int = 60000;
		
		public static const STACK_INCREASE_PER_FRAME:int = 200;
		
		public var startingDepth:int = 1;
		
		public var tf:TextField = new TextField();
		public var timer:Timer = new Timer(0);
				
		public function ShapeInstantiationDegradation()
		{
			this.addChild(tf);
			tf.width = 400;
			tf.height = 2000;
			
			tf.text = 'Starting tests: ';
			runTests();
		}
		
		public function runTests():void {
			var before:int, after:int;
			var error:Boolean = false;
			var remaining:int = RUNS;
			var shape:Shape;
			
			tf.text = '\n Instantiating ' + INVOCATIONS_PER_FRAME + ' shapes, first iteratively and then ';
			tf.text += '\n at progressively deeper call stacks: ' ;
			timer.addEventListener(TimerEvent.TIMER, function(e:Event):void{
				
				before = getTimer();
				
				var recursive:Function = function(depth:int):void {
					if (neededThisFrame > 0 && depth > 0) {
						//instantiate a Shape - degradation not present when instantiating an Object
						shape = new Shape();
						depth--;
						neededThisFrame--;
						recursive(depth);
					}
				}
				
				var neededThisFrame:int = INVOCATIONS_PER_FRAME;
				while (neededThisFrame > 0) {
					recursive(startingDepth);
				}
				
				after = getTimer();
				tf.text += '\n stack ' + startingDepth + ' deep: ' + String(after - before);
				startingDepth += STACK_INCREASE_PER_FRAME;
				
				remaining--;
				if ( remaining == 0 ) {
					timer.stop();
					tf.text += '\n tests complete!';
				}
			});
			
			timer.start();
		}	
	}
}