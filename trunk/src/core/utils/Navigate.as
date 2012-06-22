

package core.utils 
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class Navigate 
	{
		public static function getURL(url:*, window:String ):void {
			var req:URLRequest ;
			if ( url is URLRequest)
				req = url;
			else
				req = new URLRequest(url);
			
			if (! ExternalInterface.available) {
				navigateToURL(req, window);
			} 
			else {
				var strUserAgent:String=String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
				if (strUserAgent.indexOf("firefox") != -1 || (strUserAgent.indexOf("msie") != -1 && uint(strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3)) >= 7)) {
					ExternalInterface.call("window.open", req.url, window);
				} else {
					navigateToURL(req, window);
				}
			}
		}
	}

}