package core.blitting
{
	import core.blitting.cachedGFX.CachedClip;
	
	public class BListBase
	{
		public var head : CachedClip ;
		public var tail : CachedClip ;
		protected var _count : int ;
		
		public function get length() : int { return _count ; }
		
		
		public function BListBase( )
		{
			head = tail = null;
			_count = 0 ;
		}
		
		public function append( $clip : CachedClip ) : void
		{
			if ( $clip.parentList )
				throw ( new Error ( "Trying to add a CachedClip to a list when it's already in one" ) ) ;
			
			if (head)
			{
				tail.next	= $clip ; 
				$clip.prev	= tail ;
				tail		= $clip;
			}
			else
				head = tail = $clip;
			
			$clip.parentList = this ;
			++_count;
		}
		
		public function prepend( $clip : CachedClip ) : void
		{
			if ( $clip.parentList )
				throw ( new Error ( "Trying to add a CachedClip to a list when it's already in one" ) ) ;
			
			if (head)
			{
				head.prev	= $clip ;
				$clip.next = head ;
				head		= $clip ;
			}
			else
				head = tail = $clip;
			
			$clip.parentList = this ;
			++_count;
		}

		public function remove( $clip : CachedClip ) : CachedClip
		{
			
			if ( $clip.parentList != this )
				throw ( new Error ( "Trying to remove a CachedClip from a list it's not a part of" ) ) ;			
			
			if ($clip == head)
			{
				head = $clip.next ;
				if(head) head.prev	= null ;
			}
			else
				$clip.prev.next = $clip.next ;
			
			if($clip == tail)
			{
				tail = $clip.prev ;
				if (tail) tail.next = null ;
			}
			else
				$clip.next.prev = $clip.prev;
			
			$clip.prev = null ;
			$clip.next = null ;
			$clip.parentList = null ;
			
			--_count;
			return $clip ;
		}
		
		
		public function removeHead() : CachedClip
		{
			var clip : CachedClip = head ;
			
			if (head)
			{
				clip = head 
				head = clip.next ;
				if (head) head.prev	= null ;
				--_count;
				
				clip.next = null ;
				clip.parentList = null ;
				return clip ;
			}
			
			return null ;
		}
		
		public function removeTail() : CachedClip
		{
			var clip : CachedClip = tail ;
			
			if (tail)
			{
				tail = tail.prev ;
				if (tail) tail.next = null ;
				--_count;
				
				clip.prev = null ;
				clip.parentList = null ;
				return clip ;
			}
			
			return null ;
		}

		public function clear() : void
		{	
			var clip  : CachedClip ;
			
			while (head)
			{
				clip		= head ;
				head		= head.next ;
				if ( head )
					head.prev	= null ;
				clip.next	= null ;
				clip.parentList = null ;
				--_count;
			}
			
			head = null;
			tail = null;			
		}
		
		public function dump() : String
		{
			var output	: String,
			clip	: CachedClip,
			count	: int = 0;
			
			output = " List Content ( "+ _count + " elems ) : \n"
			
			if (! head)
			{
				output += "\t vide" ;
				return output ;
			}
			
			clip = head.next ;
			
			output += "\t head = " + (head? "ID:" + head.id : head) + (head == tail ? " = tail " : "" ) + (head.y ? "(y=" + head.y+ ")" : "" ) + "\n" ;
			output += "\t\t\t prev = " + (head.prev? "ID:" + head.prev.id : head.prev) + "\n" ;
			output += "\t\t\t next = " + (head.next? "ID:" + head.next.id : head.next) + "\n" ;
			++count
			
			while (clip && (clip != tail) )
			{
				output += "\t clip " + (++count) + " = " + (clip? "ID:" + clip.id : clip) + (clip.y ? "(y=" + clip.y+ ")" : "" ) + "\n" ;
				output += "\t\t\t prev = " + (clip.prev? "ID:" + clip.prev.id : clip.prev) + "\n" ;
				output += "\t\t\t next = " + (clip.next? "ID:" + clip.next.id : clip.next)+ "\n" ;
				
				clip = clip.next ;
			}
			
			if (head != tail)
			{
				output += "\t tail = " +  (tail? "ID:" + tail.id : tail)  + (tail.y ? "(y=" + tail.y+ ")" : "" ) + "\n" ;
				output += "\t\t\t prev = " + (tail.prev? "ID:" + tail.prev.id : tail.prev) + "\n" ;
				output += "\t\t\t next = " + (tail.next? "ID:" + tail.next.id : tail.next) + "\n" ;
			}
			
			
			return output ;
		}
		
	}
}