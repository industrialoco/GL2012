package core.gameObjects
{
	import core.mem.Mem;
	
	

	/**
	 * This is an organizational class that can update and render a bunch of <code>FlxBasic</code>s.
	 * NOTE: Although <code>FlxGroup</code> extends <code>FlxBasic</code>, it will not automatically
	 * add itself to the global collisions quad tree, it will only add its members.
	 * 
	 * @author	Adam Atomic
	 */
	public class GameGroup extends GameBasic
	{
		/**
		 * Use with <code>sort()</code> to sort in ascending order.
		 */
		static public const ASCENDING:int = -1;
		/**
		 * Use with <code>sort()</code> to sort in descending order.
		 */
		static public const DESCENDING:int = 1;
		
		/**
		 * Array of all the <code>FlxBasic</code>s that exist in this group.
		 */
		public var members:Array;
		public var membersLength:int = 0;
		public var recycledG:Array;
		public var recycledGLength:int = 0;
		/**
		 * The number of entries in the members array.
		 * For performance and safety you should check this variable
		 * instead of members.length unless you really know what you're doing!
		 */


		/**
		 * Helper for sort.
		 */
		protected var _sortIndex:String;
		/**
		 * Helper for sort.
		 */
		protected var _sortOrder:int;

		/**
		 * Constructor
		 */
		public function GameGroup($initParams:InstantiationParams=null)
		{
			members = Mem.array.get() as Array;
			recycledG = Mem.array.get() as Array;
			_sortIndex = null;
			super($initParams);
		}

		/**
		 * Override this function to handle any deleting or "shutdown" type operations you might need,
		 * such as removing traditional Flash children like Sprite objects.
		 */
		override protected function disposing():void
		{
			// stand alone
			var basic:GameBasic;
			var i:uint;
			var l:int;
			if(members != null)
			{
				i = 0;
				l = members.length;
				while(i < l)
				{
					basic = members[i++] as GameBasic;
					if(basic != null)
						basic.dispose();
				}
				members.length = 0;
				Mem.array.put(members);
				members = null;
				membersLength=0;
			}
			if(recycledG != null)
			{
				basic = null;
				i = 0;
				l =  recycledG.length;
				while(i < l)
				{
					basic = recycledG[i++] as GameBasic;
					if(basic != null)
						basic.dispose();
				}
				recycledG.length = 0;
				Mem.array.put(recycledG);
				recycledG = null;
				membersLength=0;
			}
			_sortIndex = null;
			super.disposing();
		}
		/**
		 * Automatically goes through and calls update on everything you added.
		 */
		protected override function rendering():void
		{
			// stand alone
			super.rendering();
			if (!members)
				return;
			var basic:GameBasic;
			var i:uint = 0;
			var l:uint = members.length
			while(i < l)
			{
				basic = members[i++] as GameBasic;
				if((basic != null) && basic.renderActive && !basic.disposed)
				{
					basic.render();
				}
			}
		}
		override protected function updating($step:uint):void
		{
			// stand alone
			super.updating($step);
			if (!members)
				return;
			var basic:GameBasic;
			var i:uint = 0;
			var l:uint = members.length;
			while(i < l)
			{
				basic = members[i++] as GameBasic;
				if(basic != null) 
				{
					if (basic.updateActive && !basic.disposed)
					{
						basic.update($step);
					}
					else if (basic.disposed)
					{
						remove(basic);
					}
					else if (basic.forRecycle)
					{
						trash(basic);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		
		/**
		 * Adds a new <code>FlxBasic</code> subclass (FlxBasic, FlxSprite, Enemy, etc) to the group.
		 * FlxGroup will try to replace a null member of the array first.
		 * Failing that, FlxGroup will add it to the end of the member array,
		 * assuming there is room for it, and doubling the size of the array if necessary.
		 *
		 * <p>WARNING: If the group has a maxSize that has already been met,
		 * the object will NOT be added to the group!</p>
		 *
		 * @param	Object		The object you want to add to the group.
		 *
		 * @return	The same <code>FlxBasic</code> object that was passed in.
		 */
		
		public function add(Object:GameBasic):GameBasic
		{
			// called from recycle
			
			//Don't bother adding an object twice.
			if(members.indexOf(Object) >= 0 || recycledG.indexOf(Object) >=0 )
				return Object;
			
			//First, look for a null entry where we can add the object.
			var i:uint = 0;
			var l:uint = members.length;
			while(i < l)
			{
				if(members[i] == null)
				{
					members[i] = Object;
					membersLength++;
					return Object;
				}
				i++;
			}
			
			//Failing that, expand the array (if we can) and add the object.
			members.length += 1;
			
			//If we made it this far, then we successfully grew the group,
			//and we can go ahead and add the object at the first open slot.
			members[i] = Object;
			membersLength++;
			return Object;
		}
		
		/**
		 * Recycling is designed to help you reuse game objects without always re-allocating or "newing" them.
		 * 
		 * <p>If you specified a maximum size for this group (like in FlxEmitter),
		 * then recycle will employ what we're calling "rotating" recycling.
		 * Recycle() will first check to see if the group is at capacity yet.
		 * If group is not yet at capacity, recycle() returns a new object.
		 * If the group IS at capacity, then recycle() just returns the next object in line.</p>
		 * 
		 * <p>If you did NOT specify a maximum size for this group,
		 * then recycle() will employ what we're calling "grow-style" recycling.
		 * Recycle() will return either the first object with exists == false,
		 * or, finding none, add a new object to the array,
		 * doubling the size of the array if necessary.</p>
		 * 
		 * <p>WARNING: If this function needs to create a new object,
		 * and no object class was provided, it will return null
		 * instead of a valid object!</p>
		 * 
		 * @param	ObjectClass		The class type you want to recycle (e.g. FlxSprite, EvilRobot, etc). Do NOT "new" the class in the parameter!
		 * 
		 * @return	A reference to the object that was created.  Don't forget to cast it back to the Class you want (e.g. myObject = myGroup.recycle(myObjectClass) as myObjectClass;).
		 */
		public function recycle(ObjectClass:Class=null, args:InstantiationParams=null):GameBasic
		{
			// stand alone
			var basic:GameBasic;

			basic = getFirstTrashed(ObjectClass);
			if(basic != null)
			{
				untrash(basic);
				return basic;
			}
			if(ObjectClass == null)
				return null;

			// no vars
			if (!args)
				return add(new ObjectClass() as GameBasic);
			else
				return add(new ObjectClass(args) as GameBasic);
			
			
			return null;

		}
		
		/**
		 * Removes an object from the group.
		 * 
		 * @param	Object	The <code>FlxBasic</code> you want to remove.
		 * @param	Splice	Whether the object should be cut from the array entirely or not.
		 * 
		 * @return	The removed object.
		 */
		public function remove(Object:GameBasic,Splice:Boolean=false):GameBasic
		{
			// called from updating
			var index:int = members.indexOf(Object);
			if((index < 0) || (index >= members.length))
				return null;
			if(Splice)
			{
				members.splice(index,1);
			}
			else
				members[index] = null;
			
			membersLength--;
			return Object;
		}

		/**
		 * Replaces an existing <code>FlxBasic</code> with a new one.
		 * 
		 * @param	OldObject	The object you want to replace.
		 * @param	NewObject	The new object you want to use instead.
		 * 
		 * @return	The new object.
		 */
		public function replace(OldObject:GameBasic,NewObject:GameBasic):GameBasic
		{
			// stand alone
			var index:int = members.indexOf(OldObject);
			if((index < 0) || (index >= members.length))
				return null;
			members[index] = NewObject;
			return NewObject;
		}
		
		/**
		 * Call this function to sort the group according to a particular value and order.
		 * For example, to sort game objects for Zelda-style overlaps you might call
		 * <code>myGroup.sort("y",ASCENDING)</code> at the bottom of your
		 * <code>FlxState.update()</code> override.  To sort all existing objects after
		 * a big explosion or bomb attack, you might call <code>myGroup.sort("exists",DESCENDING)</code>.
		 * 
		 * @param	Index	The <code>String</code> name of the member variable you want to sort on.  Default value is "y".
		 * @param	Order	A <code>FlxGroup</code> constant that defines the sort order.  Possible values are <code>ASCENDING</code> and <code>DESCENDING</code>.  Default value is <code>ASCENDING</code>.  
		 */
		public function sort(Index:String="y",Order:int=ASCENDING):void
		{
			_sortIndex = Index;
			_sortOrder = Order;
			members.sort(sortHandler);
		}
		public function sortRecycled(Index:String="y",Order:int=ASCENDING):void
		{
			_sortIndex = Index;
			_sortOrder = Order;
			recycledG.sort(sortHandler);
		}

		/**
		 * Go through and set the specified variable to the specified value on all members of the group.
		 * 
		 * @param	VariableName	The string representation of the variable name you want to modify, for example "visible" or "scrollFactor".
		 * @param	Value			The value you want to assign to that variable.
		 * @param	Recurse			Default value is true, meaning if <code>setAll()</code> encounters a member that is a group, it will call <code>setAll()</code> on that group rather than modifying its variable.
		 */
		public function setAll(VariableName:String,Value:Object,Recurse:Boolean=true):void
		{
			// stand alone
			var basic:GameBasic;
			var i:uint = 0;
			var l:int =  members.length;
			while(i <  l)
			{
				basic = members[i++] as GameBasic;
				if(basic != null)
				{
					if(Recurse && (basic is GameGroup))
						(basic as GameGroup).setAll(VariableName,Value,Recurse);
					else
						basic[VariableName] = Value;
				}
			}
		}
		public function setAllRecycled(VariableName:String,Value:Object,Recurse:Boolean=true):void
		{
			// stand alone
			var basic:GameBasic;
			var i:uint = 0;
			var l:int =  recycledG.length;
			while(i <  l)
			{
				basic = recycledG[i++] as GameBasic;
				if(basic != null)
				{
					if(Recurse && (basic is GameGroup))
						(basic as GameGroup).setAllRecycled(VariableName,Value,Recurse);
					else
						basic[VariableName] = Value;
				}
			}
		}
		
		/**
		 * Go through and call the specified function on all members of the group.
		 * Currently only works on functions that have no required parameters.
		 * 
		 * @param	FunctionName	The string representation of the function you want to call on each object, for example "kill()" or "init()".
		 * @param	Recurse			Default value is true, meaning if <code>callAll()</code> encounters a member that is a group, it will call <code>callAll()</code> on that group rather than calling the group's function.
		 */ 
		public function callAll(FunctionName:String,Recurse:Boolean=true):void
		{
			// stand alone
			var basic:GameBasic;
			var i:uint = 0;
			var l:int =  members.length;
			while(i < l)
			{
				basic = members[i++] as GameBasic;
				if(basic != null)
				{
					if(Recurse && (basic is GameGroup))
						(basic as GameGroup).callAll(FunctionName,Recurse);
					else
						basic[FunctionName]();
				}
			}
		}
		public function callAllRecycled(FunctionName:String,Recurse:Boolean=true):void
		{
			// stand alone
			var basic:GameBasic;
			var i:uint = 0;
			var l:int =  recycledG.length;
			while(i < l)
			{
				basic = recycledG[i++] as GameBasic;
				if(basic != null)
				{
					if(Recurse && (basic is GameGroup))
						(basic as GameGroup).callAllRecycled(FunctionName,Recurse);
					else
						basic[FunctionName]();
				}
			}
		}
		
		/**
		 * Call this function to retrieve the first object with exists == false in the group.
		 * This is handy for recycling in general, e.g. respawning enemies.
		 * 
		 * @param	ObjectClass		An optional parameter that lets you narrow the results to instances of this particular class.
		 * 
		 * @return	A <code>FlxBasic</code> currently flagged as not existing.
		 */
		public function getFirstTrashed(ObjectClass:Class=null):GameBasic
		{
			// called from recycle
			var basic:GameBasic;
			var i:uint = 0;
			var l:int =  recycledG.length;
			while(i <  l)
			{
				basic = recycledG[i++] as GameBasic;
				if((basic != null) && ((ObjectClass == null) || ((basic as ObjectClass)!= null)))
					return basic;
			}
			return null;
		}

		public function clear():void
		{
			members.length = 0;
			recycledG.length = 0;
		}
		
		override public function toRecycle():void
		{
			// marca a todos sus child para recycle
			// called from trash
			var basic:GameBasic;
			var i:uint = 0;
			var l:int =  members.length;
			while(i <  l)
			{
				basic = members[i++] as GameBasic;
				if(basic != null)
				{
					basic.toRecycle();

				}
			}
			super.toRecycle();
		}
		public function trash(Object:GameBasic):void
		{
			
			// stand alone
			if (!Object)
				return;
			
			membersLength--;
			if (!Object.forRecycle)
			{
				Object.toRecycle();
			}
			if (!Object.recycled)
			{
				members[members.indexOf(Object)] = null;
				addToRecycledArray(Object);
				Object.recycled = true;
			}

			if (Object is GameGroup)
			{
				var gg:GameGroup = Object as GameGroup;
				for (var i:int = gg.members.length-1; i >=0; i--) 
				{
					gg.trash(gg.members[i]);
				}
				gg = null;
			}
		}
		private function addToRecycledArray(Object:GameBasic):void
		{
			var i:int = 0;
			var l:int = recycledG.length;
			for (i = 0; i < l; i++) 
			{
				if (recycledG[i] == null)
				{
					recycledG[i]=Object;
					recycledGLength++;
					return;
				}
			}

			recycledG.length += 1;
			recycledG[i] = Object;
			recycledGLength++;
		}
		private function addToMembersArray(Object:GameBasic):void
		{
			var i:int = 0;
			var l:int = members.length;
			for (i = 0; i < l; i++) 
			{
				if (members[i] == null)
				{
					members[i]=Object;
					membersLength++;
					return;
				}
			}

			members.length += 1;
			members[i] = Object;
			membersLength++;
		}
		public function untrash(Object:GameBasic):void
		{
			// called from recycle
			if (!Object)
				return;
			var idx:int = recycledG.indexOf(Object)
			if ( idx >= 0)
			{
				recycledG[idx] = null;
				recycledGLength--;
			}

			var i:uint = 0;
			var l:uint = members.length;
			membersLength++;
			while(i < l)
			{
				if(members[i] == null)
				{
					members[i] = Object;
					Object.revive();
					return;
				}
				i++;
			}
			
			members.length += 1;
			members[i] = Object;
			
			Object.revive();
		}
		/**
		 * Helper function for the sort process.
		 * 
		 * @param 	Obj1	The first object being sorted.
		 * @param	Obj2	The second object being sorted.
		 * 
		 * @return	An integer value: -1 (Obj1 before Obj2), 0 (same), or 1 (Obj1 after Obj2).
		 */
		protected function sortHandler(Obj1:GameBasic,Obj2:GameBasic):int
		{
			if(Obj1[_sortIndex] < Obj2[_sortIndex])
				return _sortOrder;
			else if(Obj1[_sortIndex] > Obj2[_sortIndex])
				return -_sortOrder;
			return 0;
		}
		public override function disableUpdate():void
		{
			// stand alone
			super.disableUpdate();
			var basic:GameBasic;
			var i:uint = 0;
			var l:int =  members.length;
			while(i <  l)
			{
				basic = members[i++] as GameBasic;
				if((basic != null) && basic.updateActive)
				{
					basic.disableUpdate();
				}
			}
		}
		public override function enableUpdate():void
		{
			// stand alone
			super.enableUpdate();
			var basic:GameBasic;
			var i:uint = 0;
			var l:int =  members.length;
			while(i <  l)
			{
				basic = members[i++] as GameBasic;
				if((basic != null) && !basic.updateActive)
				{
					basic.enableUpdate();
				}
			}
		}
	}
}
