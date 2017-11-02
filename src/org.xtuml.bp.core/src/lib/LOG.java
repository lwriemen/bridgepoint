//========================================================================
// Licensed under the Apache License, Version 2.0 (the "License"); you may not 
// use this file except in compliance with the License.  You may obtain a copy 
// of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   See the 
// License for the specific language governing permissions and limitations under
// the License.
//======================================================================== 

package lib;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.UUID;

import org.xtuml.bp.core.CorePlugin;

public class LOG {

	// ============================================================================
	// Bridge: LogSuccess
	// ============================================================================
	public static void LogSuccess(String ee_message) {

		CorePlugin.out.println("LogSuccess:  " + ee_message);

	}

	// ============================================================================
	// Bridge: LogFailure
	// ============================================================================
	public static void LogFailure(String ee_message) {

		CorePlugin.out.println("LogFailure:  " + ee_message);

	}

	// ============================================================================
	// Bridge: LogInfo
	// ============================================================================
	public static void LogInfo(String ee_message) {

		CorePlugin.out.println("LogInfo:  " + ee_message);

	}

	// ============================================================================
	// Bridge: LogDate
	// ============================================================================
	public static void LogDate(String ee_message, Object ee_d) {
		String objString = null;
				if (ee_d != null) {
					SimpleDateFormat format = new SimpleDateFormat(
							"EEE MMM dd yyyy HH:mm:ss zzz");
					Date date = ((GregorianCalendar) ee_d).getTime();
					objString = format.format(date);
				}
				CorePlugin.out.println("LogDate:  " + objString + " " + ee_message);

	}

	// ============================================================================
	// Bridge: LogTime
	// ============================================================================
	public static void LogTime(String ee_message, Object ee_t) {
		String objString = (ee_t == null) ? "<null>" : ee_t.toString();

		CorePlugin.out.println("LogTime:  " + objString + " " + ee_message);
	}

	// ========================================================================
	// Bridge: LogInteger
	// ========================================================================
	public static void LogInteger(String ee_message, int ee_i) {

		CorePlugin.out.println("LogInteger:  " + ee_i + " " + ee_message);

	}

	// ============================================================================
	// Bridge: LogReal
	// ============================================================================
	public static void LogReal(String ee_message, float ee_r) {

		CorePlugin.out.println("LogReal:  " + ee_r + " " + ee_message);

	}

	// ============================================================================
	// Bridge: LogUnique_ID 
	// ============================================================================
	public static void LogUnique_ID(String ee_message, UUID ee_id) {
		String objString = (ee_id == null) ? "<null>" : ee_id.toString();

		CorePlugin.out.println("LogUUID:  " + objString + " "
				+ ee_message);

	}
}
