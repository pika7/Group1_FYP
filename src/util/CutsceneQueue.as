package util
{
	/**
	 * An implementation of a linked Queue Datastructure. From Java.
	 *
	 *@author Michael Avila
	 *@version 1.0.0
	 * 
	 * 
	 */

	  
	public class CutsceneQueue {
		private var first:Node;
		private var last:Node;
		
		public function isEmpty():Boolean {
			return (first == null);
		}
		
		public function enqueue(data:CutsceneInstruction):void {
			var node:Node = new Node();
			node.data = data;
			node.next = null;
			if (isEmpty()) {
				first = node;
				last = node;
			} else {
				last.next = node;
				last = node;
			}
		}
		
		public function dequeue():CutsceneInstruction {
			if (isEmpty()) {
				trace("Error: \n\t Objects of type Queue must contain data before being dequeued.");
				return null;
			}
			var data:CutsceneInstruction = first.data;
			first = first.next;
			return data;
		}
		
		public function peek() : CutsceneInstruction
		{
			if (isEmpty()) {
				trace("Error: \n\t Objects of type Queue must contain data before you can peek.");
			}
			return first.data;
		}
	}
}