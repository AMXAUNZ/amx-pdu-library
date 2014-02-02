amx-pdu-library
===============


Files
-----
+ amx-pdu-api.axi
+ amx-pdu-control.axi
+ amx-pdu-listener.axi


Overview
--------
The **amx-pdu-library** NetLinx library is intended as a tool to make things easier for anyone tasked with programming an AMX system containing an AMX Power Distribution Unit (PDU):

+ NXA-PDU1508-08

The built-in structures, constants, control functions, callback functions, and events assist you by simplifying control and feedback.

Everything is a function!

Consistent, descriptive control function names within **amx-pdu-control** make it easy for you to control the different aspects of the PDU (relays, trigger values, temperature scale, etc...) and request information. E.g:

	/*
	 * Function:	pduSetPowerTriggerSenseValue
	 * 
	 * Arguments:	dev pduPort1 - port 1 device on the PDU
	 *				integer outlet - outlet port on the PDU
	 *				integer triggerValue - trigger sense value
	 * 
	 * Description:	Set Trigger Sense Value for PDU Power Outlet.
	 */
	define_function pduSetPowerTriggerSenseValue (dev pduPort1, integer outlet, integer triggerValue)
	{
		sendCommand (pduPort1, "PDU_COMMAND_POWER_SENSE_TRIGGER,itoa(outlet),',',itoa(triggerValue)")
	}

No longer are you required to refer to the PDU manual to work out what command headers are required or how to build a control string containing all the required values. This process was time consuming and often involved converting numeric data to string form and building string expressions which were long and complex.

With the control functions defined within **amx-pdu-control** values for PDU commands are simply passed through as arguments in the appropriate data types (constants defined within **amx-pdu-api** can be used where required) and the control functions do the hard work.

Similarly, you no longer have to build events (data/channel/level, etc...) to capture returning information from the PDU and parse the incoming string/command (coverting data types where required) to obtain the required information in the correct format. **amx-pdu-listener**, listens for all types of responses from the PDU and triggers pre-written callback functions which you can copy to the main program, uncomment and fill in. E.g:

	#define INCLUDE_PDU_NOTIFY_OVER_CURRENT_CALLBACK
	define_function pduNotifyOverCurrent (dev pduPort1, integer outlet, float current)
	{
		// pduPort1 is port 1 on the PDU
		// outlet is the outlet of the PDU which is reporting overcurrent. If nPduOutlet is zero (0) then entire PDU is over current.
		// current is the current (in Amps)
	}

Functions also assist to neaten up the programming and provide added readability to the code and the auto-prompter within the NetLinx Studio editor makes it easy to find the function you're looking for.

Extremely flexible!

All control and callback functions have a DEV parameter. This makes **amx-pdu-library** extremely flexible as you can use the same control/callback functions for different ports on a PDU or even multiple PDU's. For the control functions you simply pass through the dev for the PDU component you want to control and the dev parameter of the callback functions allows you to check to see which device triggered the notification.


amx-pdu-api
-----------
#####Dependencies:
+ none

#####Description:
Contains structure definitions which you can use to store information about an AMX Power Distribution Unit.

Contains constants for PDU NetLinx command headers and parameter values. These are used extensively by the accompanying library files **amx-pdu-control** and **amx-pdu-listener**. The constants defined within **amx-pdu-api** can also be referenced when passing values to control functions (where function parameters have a limited allowable set of values for one or more parameters) or checking to see the values of the callback function parameters.

#####Usage:
Include **amx-pdu-api** into the main program using the `#include` compiler directive. E.g:

	#include 'amx-pdu-api'

NOTE: If the main program file includes **amx-pdu-control** and/or **amx-pdu-listener** it is not neccessary to include **amx-pdu-api** in the main program file as well as each of them already includes **amx-pdu-api** but doing so will not cause any issues.


amx-pdu-control
---------------
#####Dependencies:
+ amx-pdu-api
+ amx-device-control (*see readme for amx-device-library for info*)

#####Description: 
Contains functions for controlling the various components of an AMX Power Distribution Unit and requesting information from the PDU.

Some functions defined within **amx-pdu-control** have an limited allowable set of values for one or more parameters. In these instances the allowable values will be printed within the accompanying commenting as constants defined within **amx-pdu-api**.

#####Usage:
Include **amx-pdu-control** into the main program using the `#include` compiler directive. E.g:

	#include 'amx-pdu-control'

and call the function(s) defined within **amx-pdu-control** from the main program file,. E.g:

	button_event [dvTp,btnKillPowerToDisplayMonitor]
	{
		push:
		{
			pduDisableRelayPower (dvPduOutletDisplayMonitor)
		}
	}

	button_event [dvTp,btnRestorePowerToDisplayMonitor]
	{
		push:
		{
			pduEnableRelayPower (dvPduOutletDisplayMonitor)
		}
	}


amx-pdu-listener
----------------
#####Dependencies:
+ amx-pdu-api

#####Description:
Contains dev arrays for listening to traffic returned from the AMX Power Distribution Switcher.

You should copy the required dev arrays to their main program and instantiate them with dev values corresponding to the PDU components you wish to listen to.

Contains commented out callback functions and events required to capture information from the AMX Power Distibution Unit. The events (data_events, channel_events, & level_events) will parse the information returned from the PDU and call the associated callback functions passing the information through as arguments to the call back functions' parameter list.

Callback functions may be triggered from both unprompted data and responses to requests for information.

#####Usage:
Include **amx-pdu-listener** into the main program using the `#include` compiler directive. E.g:

	#include 'amx-pdu-listener'

Copy the required DEV arrays from **amx-pdu-listener**:

	define_variable

	#if_not_defined pduOutletPorts
	dev pduOutletPorts[] = {85:1:0, 86:1:0, 87:1:0, 88:1:0, 89:1:0, 90:1:0, 91:1:0, 92:1:0}
	#end_if

to the main program file and populate the contents of the DEV arrays with only the ports of the PDU that you want to listen to. E.g:

	define_device

	dvPduOutletDisplayMonitor = 85:1:0
	dvPduOutletAmplifier = 86:1:0
	dvPduOutletDocCam = 87:1:0

	define_variable

	// DEV array for PDU outlets copied from amx-pdu-listener
	dev pduOutletPorts[] = { dvPduOutletDisplayMonitor, dvPduOutletAmplifier, dvPduOutletDocCam }

NOTE: The order of the devices within the DEV arrays does not matter. You can also have device ports from multiple PDU's within the same DEV array. You can have as few (1) or as many devices defined within the DEV array as you want to listen to.

Copy whichever callback functions you would like to use to monitor changes on the PDU or capture responses to requests for information in your main program file. The callback function should then be uncommented and the contents of the statement block filled in appropriately. The callback functions should not be uncommented within **amx-pdu-listener**. E.g:

Copy an empty, commented out callback function from **amx-pdu-listener** and the associated `#define` statement:

	/*
	#define INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
	define_function pduNotifyOutletRelay (dev pduOutletPort, integer relayStatus)
	{
		// pduOutletPort is an outlet device on the PDU
		// relayStatus indicates whether the relay is on (TRUE) or off (FALSE)
	}
	*/

paste the callback function and `#define` statement into the main program file, uncomment, and add any code statements you want:

	#define INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
	define_function pduNotifyOutletRelay (dev pduOutletPort, integer relayStatus)
	{
		// pduOutletPort is an outlet device on the PDU
		// relayStatus indicates whether the relay is on (TRUE) or off (FALSE)
		
		if (pduOutletPort == dvPduOutletDocCam)
		{
			[dvTp,btnMainsPowerStatusDocCam] = relayStatus
		}
	}

The callback function will be automatically triggered whenever a change occurs on the PDU (that initiates an unsolicted feedback response) or a response to a request for information is received.

###IMPORTANT!
1. The `#define` compiler directive found directly above the callback function within **amx-pdu-listener** must also be copied to the main program and uncommented along with the callback function itself.

2. Due to the way the NetLinx compiler scans the program for `#define` staments **amx-pdu-listener** must be included in the main program file underneath any callback functions and associated `#define` statements or the callback functions will not trigger.

E.g:

		#program_name='main program'
			
		define_device
		
		dvPduMain = 85:1:0
		dvPduAxlinkBus1 = 85:1:0
		dvPduAxlinkBus2 = 86:1:0
		dvPduOutletDisplayMonitor = 85:1:0
		dvPduOutletAmplifier = 86:1:0
		dvPduOutletDocCam = 87:1:0
			
		define_variable
			
		// DEV arrays for amx-pdu-listener to use
		dvPduMains1[] = { dvPduMain }
		dev pduOutletPorts[] = { dvPduOutletDisplayMonitor, dvPduOutletAmplifier, dvPduOutletDocCam }
		
		#define INCLUDE_PDU_NOTIFY_INPUT_VOLTAGE_CALLBACK
		define_function pduNotifyInputVoltage (dev pduPort1, float voltage)
		{
		}
		
		#define INCLUDE_PDU_NOTIFY_OVER_CURRENT_CALLBACK
		define_function pduNotifyOverCurrent (dev pduPort1, integer outlet, float current)
		{
		}
		
		#define INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
		define_function pduNotifyOutletRelay (dev pduOutletPort, integer relayStatus)
		{
		}
		
		#define INCLUDE_PDU_NOTIFY_AXLINK_CURRENT
		define_function pduNotifyAxlinkCurrent (dev pduAxlinkBus, float current)
		{
		}
		
		#include 'amx-pdu-listener'

---------------------------------------------------------------

Author: David Vine - AMX Australia  
Readme formatted with markdown  
Any questions, email <support@amxaustralia.com.au> or phone +61 (7) 5531 3103.
