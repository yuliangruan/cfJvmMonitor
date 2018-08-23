/**
 * dynamic cfchart adaptation of https://blog.pengoworks.com/index.cfm/2007/12/13/Quirk-n-Dirty-ColdFusion-JVM-Memory-Monitor
 */
component {

	/**
	* Pass in a value in bytes, and this function converts it to a human-readable format of bytes, KB, MB, or GB.
	* Updated from Nat Papovich's version.
	* 01/2002 - Optional Units added by Sierra Bufe (sierra@brighterfusion.com)
	*
	* @param size     Size to convert.
	* @param unit     Unit to return results in. Valid options are bytes,KB,MB,GB.
	* @return Returns a string.
	* @author Paul Mone (sierra@brighterfusion.compaul@ninthlink.com)
	* @version 2.1, January 7, 2002
	*/
	private function byteConvert(numeric num, string unit="", withUnit=false) {
		var result = 0;
	// Set unit variables for convenience
		var bytes = 1;
		var kb = 1024;
		var mb = 1048576;
		var gb = 1073741824;
		// Check for non-numeric or negative num argument
		if (not isNumeric(num) OR num LT 0)
			return "Invalid size argument";
		// Check to see if unit was passed in, and if it is valid
		if (len(arguments.unit) GT 0
			AND ("bytes,KB,MB,GB" contains arguments.unit))
		{
			unit = Arguments.unit;
		// If not, set unit depending on the size of num
		} else {
			 if     (num lt kb) {    unit ="bytes";
			} else if (num lt mb) {    unit ="KB";
			} else if (num lt gb) {    unit ="MB";
			} else                {    unit ="GB";
			}
		}
		// Find the result by dividing num by the number represented by the unit
		result = num / Evaluate(unit);
		// Format the result
		if (result lt 10)
		{
			result = NumberFormat(Round(result * 100) / 100,"0.00");
		} else if (result lt 100) {
			result = NumberFormat(Round(result * 10) / 10,"90.0");
		} else {
			result = Round(result);
		}
		// Concatenate result and unit together for the return value
		if (arguments.withUnit)
			return (result & " " & unit);
		else
			return result;
	}
	private function formatMB(num){
		return byteConvert(num, "MB");
	}

	public function jvmMemData(string group="") {
		// Create Java object instances needed for creating memory charts
		var runtime = createobject("java", "java.lang.Runtime");
		var mgmtFactory = createobject("java", "java.lang.management.ManagementFactory");
		var pools = mgmtFactory.getMemoryPoolMXBeans();
		var heap = mgmtFactory.getMemoryMXBean();
		var jvm = structNew();

		if (len(arguments.group)==0 OR arguments.group=='1') {
			jvm["JVM - Used Memory"] = formatMB(runtime.getRuntime().maxMemory()-runtime.getRuntime().freeMemory());
			jvm["JVM - Max Memory"] = formatMB(runtime.getRuntime().maxMemory());
			jvm["JVM - Free Memory"] = formatMB(runtime.getRuntime().freeMemory());
			jvm["JVM - Total Memory"] = formatMB(runtime.getRuntime().totalMemory());
		}
		if (len(arguments.group)==0 OR arguments.group=='2') {
			jvm["Heap Memory Usage - Max"] = formatMB(heap.getHeapMemoryUsage().getMax());
			jvm["Heap Memory Usage - Used"] = formatMB(heap.getHeapMemoryUsage().getUsed());
			jvm["Heap Memory Usage - Committed"] = formatMB(heap.getHeapMemoryUsage().getCommitted());
			jvm["Heap Memory Usage - Initial"] = formatMB(heap.getHeapMemoryUsage().getInit());
			jvm["Non-Heap Memory Usage - Max"] = formatMB(heap.getNonHeapMemoryUsage().getMax());
			jvm["Non-Heap Memory Usage - Used"] = formatMB(heap.getNonHeapMemoryUsage().getUsed());
			jvm["Non-Heap Memory Usage - Committed"] = formatMB(heap.getNonHeapMemoryUsage().getCommitted());
			jvm["Non-Heap Memory Usage - Initial"] = formatMB(heap.getNonHeapMemoryUsage().getInit());
		}
		if (len(arguments.group)==0 OR arguments.group=='3') {
			for( var i=1; i lte arrayLen(pools); i=i+1 )
				jvm["Memory Pool - #pools[i].getName()# - Used"] = formatMB(pools[i].getUsage().getUsed());
		}
		
		return jvm;
	}

	remote function jvmMemData_cfchart_config(string group="") returnType="string" returnFormat="JSON" {
		var data=jvmMemData(group=arguments.group);
		
		return StructKeyList(data);
	}

	remote function jvmMemData_feed(string group="") returnType="array" returnFormat="JSON" {
		var data=jvmMemData(group=arguments.group);

		var ret=[];
		var i=0;
		var plots={};
		var i=0;
		for (var type in data) {
			plots["plot#i#"] = data[type];
			i++;
		}
		plots["scale-x"]=TimeFormat(now());

		ArrayAppend(ret,plots);

		return ret;
	}
}
