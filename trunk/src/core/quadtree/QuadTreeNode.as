package core.quadtree
{
	import core.gameObjects.CachedClipActor;
	import core.mem.Mem;
	
	import flash.utils.Dictionary;

	public class QuadTreeNode
	{
		// a double linked list of objects
		public var objects:Vector.<CachedClipActor>;
		public var objsByGroup:Dictionary;
		
		// the single nodes 0 - 3 (0 left-top, 1 right-top, 2 left-bottom, 3 right-bottom)
		public var _parent:QuadTreeNode = null;
		private var _0:QuadTreeNode = null;
		private var _1:QuadTreeNode = null;
		private var _2:QuadTreeNode = null;
		private var _3:QuadTreeNode = null;
		
		// a NodeDimension object which stores the information for the dimension of this node
		public var nodeDimension:NodeDimension;
		
		protected var _main:QuadTree;
		
		public function QuadTreeNode()
		{
			objects = new Vector.<CachedClipActor>();
			objsByGroup = Mem.dict.get() as Dictionary;
			nodeDimension = new NodeDimension();
		}
		public function init(parent:QuadTreeNode, $main:QuadTree):void
		{
			_main = $main;
			_parent = parent;
		}
		// returns the QuadTreeNodes
		public function getNode(pos:int):QuadTreeNode {
			switch(pos)
			{
				case 0: return _0;
					break;
				case 1: return _1;
					break;
				case 2: return _2;
					break;
				case 3: return _3;
					break;
				default:
					throw("Error GETTING node: Only four nodes are available (0 - 3).");
			}
		}
		
		// check if the single TreeObjects in _objects array has changed their position within the tree (has they changed to a subnode or to a parent node?)
		
		private var tmpObj:CachedClipActor;
		private var tmpNode:QuadTreeNode;
		
		public function update():void 
		{
			for (var k:Object in objsByGroup)
			{
				objsByGroup[k].length=0;
			}
			tmpObj = null;

			for(var i:int=objects.length-1; i>=0 ; i--)
			{
				tmpObj = objects.shift() as CachedClipActor;
				if(tmpObj)
					updateObject(tmpObj);
			}

			tmpObj = null;
			for(var j:int=0; j < 4; j++)
			{
				tmpNode = getNode(j) as QuadTreeNode;
				if(tmpNode)
					tmpNode.update();
			}
			tmpNode = null;
		}
		
		// insert a new node
		public function insertNode(treeObject:CachedClipActor):void {
			
			if(nodeDimension.nodeSize < 64)
			{
				setObject(treeObject);
				return;
			}
			
			var i:int = getSubQuad(treeObject.left, nodeDimension.middleX, treeObject.top, nodeDimension.middleY);
			var j:int = getSubQuad(treeObject.right, nodeDimension.middleX, treeObject.bottom, nodeDimension.middleY);
			
			// if the object doesn't lay on a line create another node
			// else: store the object in the object array
			if(i==j)
			{
				// set the node to the given position and return it
				//var tmpNode:QuadTreeNode = setNode(i);
				tmpNode = setNode(i) as QuadTreeNode;
				
				// divide the width and the height
				tmpNode.nodeDimension.nodeSize = nodeDimension.nodeSize / 2;
				
				// calculate the new position of the quad
				switch(i)
				{
					case 0: // top-left
						tmpNode.nodeDimension.x = nodeDimension.x;
						tmpNode.nodeDimension.y = nodeDimension.y;
						break;
					case 1: // top-right
						tmpNode.nodeDimension.x = nodeDimension.middleX;
						tmpNode.nodeDimension.y = nodeDimension.y;
						break;
					case 2: // bottom-left
						tmpNode.nodeDimension.x = nodeDimension.x;
						tmpNode.nodeDimension.y = nodeDimension.middleY;
						break;
					case 3: // bottom-right
						tmpNode.nodeDimension.x = nodeDimension.middleX;
						tmpNode.nodeDimension.y = nodeDimension.middleY;
						break;
					default:
						throw("Error calculating the node: only nodes between 0-3 are possible.");
				}
				
				tmpNode.insertNode(treeObject);
				tmpNode = null;
			}
			else
			{
				setObject(treeObject);
			}
		}
		public function remove($obj:CachedClipActor):void
		{
			_collisionGroup = $obj.collisionGroup;
			if (objects.length>0)
			{
				objects[objects.indexOf($obj)] = objects[objects.length-1];
				objects.pop();
			}
			if (objsByGroup[_collisionGroup] && objsByGroup[_collisionGroup].length>0)
			{
				objsByGroup[_collisionGroup][objsByGroup[_collisionGroup].indexOf($obj)] = objsByGroup[_collisionGroup][objsByGroup[_collisionGroup].length-1];
				objsByGroup[_collisionGroup].pop();
			}
			_collisionGroup = null;
		}
		// check if the node hasn't any other nodes
		private function isEmpty():Boolean {
			if(_0==null && _1==null && _2==null && _3==null)
				return true;
			else
				return false;
		}
		
		// check if the objects array is set
		private function isObjectSet():Boolean {
			if(objects.length==0)
				return false;
			else
				return true;
		}
		
		// pushes a TreeObject to the objects array
		
		private var _collisionGroup:String;
		private function setObject(treeObject:CachedClipActor):void 
		{
			objects.push(treeObject);
			_collisionGroup = treeObject.collisionGroup;
			if ( _collisionGroup != null)
			{
				if (!objsByGroup[_collisionGroup])
					objsByGroup[_collisionGroup] = new Vector.<CachedClipActor>();
				objsByGroup[_collisionGroup].push(treeObject);
				_collisionGroup = null;
			}
			treeObject.node = this;
		}
		
		// sets the given position to the right QuadTreeNode
		// if the Node isn't set, create a new one and return, else return the right node
		private function setNode(pos:int):QuadTreeNode {
			switch(pos)
			{
				case 0:
					if (_0 == null)
					{
						_0 = Mem.qtnodePool.get() as QuadTreeNode;
						_0.init(this, _main);
					}
					return _0;
					break;
				case 1:
					if (_1 == null)
					{
						_1 = Mem.qtnodePool.get() as QuadTreeNode;
						_1.init(this, _main);
					}
					return _1;
					break;
				case 2:
					if (_2 == null)
					{
						_2 = Mem.qtnodePool.get() as QuadTreeNode;
						_2.init(this, _main);
					}
					return _2;
					break;
				case 3:
					if (_3 == null)
					{
						_3 = Mem.qtnodePool.get() as QuadTreeNode;
						_3.init(this, _main);
					}
					return _3;
					break;
				default:
					throw("Error SETTING node: Only four nodes are available. from 0 - 3");
			}
		}
		
		// destroy a node by setting it to null
		private function destroyChildNode(pos:uint):void {
			switch(pos)
			{
				case 0:
					_0.destroy();
					Mem.qtnodePool.put(_0);
					_0 = null;
					break;
				case 1:
					_1.destroy();
					Mem.qtnodePool.put(_1);
					_1 = null;
					break;
				case 2:
					_2.destroy();
					Mem.qtnodePool.put(_2);
					_2 = null;
					break;
				case 3:
					_3.destroy();
					Mem.qtnodePool.put(_3);
					_3 = null;
					break;
				default:
					throw("Error DELETING node: Only four nodes are available (0 - 3).");
			}
		}
		private var obj:Object;
		public function destroy():void
		{
			for (obj in objsByGroup) 
			{
				objsByGroup[obj].length=0;
			}
			obj=null;
			objects.length=0;
			_parent = null;
		}
		// returns the number of the subquad the x1 and y1 position is lying in
		private function getSubQuad(x1:Number, x2:Number, y1:Number, y2:Number):int {
			return (x1 < x2 ? 0 : 1) | (y1 < y2 ? 0 : 2);
		}
		
		// updates a single object and sort it to a new node if neccesseary (sub or parent)
		private function updateObject(obj:CachedClipActor):void 
		{
			removeEmptyNodes();
			
			// first check if the object still lies in the same quad
			if(obj.left >= nodeDimension.x && obj.right <= nodeDimension.right && obj.top >= nodeDimension.y && obj.bottom <= nodeDimension.bottom)
			{
				insertNode(obj);
			}
			else
			{
				if(_parent == null)
					throw("Error: Object is out of area.");
				else {
					_parent.updateObject(obj);
				}
			}
			
			// remove empty nodes
			removeEmptyNodes();
		}

		private function removeEmptyNodes():void {
			for(var i:int=0; i<4; i++)
			{
				tmpNode = getNode(i) as QuadTreeNode;
				if(tmpNode)
				{
					if(!tmpNode.isObjectSet() && tmpNode.isEmpty())
					{
						destroyChildNode(i);
					}
				}
			}
			tmpNode = null;
		}
	}
}