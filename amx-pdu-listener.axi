PROGRAM_NAME='amx-pdu-listener'

#if_not_defined __AMX_PDU_LISTENER__
#define __AMX_PDU_LISTENER__

/*
 * --------------------
 * amx-pdu-listener
 *
 * For usage, check out the readme for the amx-pdu-library.
 * --------------------
 */


define_constant

char VERSION_AMX_PDU_LISTENER[] = 'v1.0.0'

include 'amx-pdu-api'


/*
 * --------------------
 * Device arrays
 * --------------------
 */

define_variable

// PDU first device used specifically to read (input voltage, and temperature)
#if_not_defined dvPduMains1
dev dvPduMains1[] = {85:1:0}
#end_if

// PDU second device used speficially to read Axlink voltage
#if_not_defined dvPduMains2
dev dvPduMains2[] = {86:1:0}
#end_if

// PDU Power Outlets for controlling power relays and reading power, current, power factor, energy
#if_not_defined pduOutletPorts
dev pduOutletPorts[] = {85:1:0, 86:1:0, 87:1:0, 88:1:0, 89:1:0, 90:1:0, 91:1:0, 92:1:0}
#end_if

// PDU Axlink Buses for controlling axlink power and reading axlink power and current
#if_not_defined dvPduAxlinkBuses
dev dvPduAxlinkBuses[] = {85:1:0, 86:1:0}
#end_if







/*
 * --------------------
 * Callback functions
 * --------------------
 */

/*
#define INCLUDE_PDU_NOTIFY_OVER_CURRENT_CALLBACK
define_function pduNotifyOverCurrent (dev pduPort1, integer outlet, float current)
{
	// pduPort1 is port 1 on the PDU
	// outlet is the outlet of the PDU which is reporting overcurrent. If nPduOutlet is zero (0) then entire PDU is over current.
	// current is the current (in Amps)
}
*/


/*
#define INCLUDE_PDU_NOTIFY_PERSIST_STATE_ALL_OUTLETS_CALLBACK
define_function pduNotifyPersistStateAllOutlets (dev pduPort1, integer outletPersistStates[])
{
	// pduPort1 is port 1 on the PDU
	// outletPersistStates is an array containing the persist state of each outlet on the PDU
}
*/

/*
#define INCLUDE_PDU_NOTIFY_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyPowerSenseTrigger (dev pduPort1, integer outlet, float triggerValue)
{
	// pduPort1 is port 1 on the PDU
	// outlet is the outlet of the PDU which is reporting the power sense trigger value
	// triggerValue is the power sense trigger value
}
*/

/*
#define INCLUDE_PDU_NOTIFY_OUTLET_OVER_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyOutletOverPowerSenseTrigger (dev pduOutletPort)
{
	// pduOutletPort is an outlet device on the PDU which has gone over the power sense trigger value
}
*/

/*
#define INCLUDE_PDU_NOTIFY_OUTLET_UNDER_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyOutletUnderPowerSenseTrigger (dev pduOutletPort)
{
	// pduOutletPort is an outlet device on the PDU which has gone under the power sense trigger value
}
*/

/*
#define INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
define_function pduNotifyOutletRelay (dev pduOutletPort, integer relayStatus)
{
	// pduOutletPort is an outlet device on the PDU
	// relayStatus indicates whether the relay is on (TRUE) or off (FALSE)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_PHASE_ANGLE_CALLBACK
define_function pduNotifyPhaseAngle (dev pduPort1, integer outlet, float phaseAngle)
{
	// pduPort1 is port 1 on the PDU
	// outlet is the outlet of the PDU which is reporting the phase angle
	// phaseAngle is the phase angle value
}
*/

/*
#define INCLUDE_PDU_NOTIFY_SERIAL_NUMBER_CALLBACK
define_function pduNotifySerialNumber (dev pduPort1, char serialNumber[])
{
	// pduPort1 is port 1 on the PDU
	// serialNumber is the serial number of the PDU
}
*/

/*
#define INCLUDE_PDU_NOTIFY_VERSION_CALLBACK
define_function pduNotifyVersion (dev pduPort1, float version)
{
	// pduPort1 is port 1 on the PDU
	// version is the version of firmware running on the PDU
}
*/

/*
#define INCLUDE_PDU_NOTIFY_INPUT_VOLTAGE_CALLBACK
define_function pduNotifyInputVoltage (dev pduPort1, float voltage)
{
	// pduPort1 is the first device on the PDU
	// voltage is the input voltage (V): Resolution to 0.1V (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_TEMPERATURE_CALLBACK
define_function pduNotifyTemperature (dev pduPort1, float temperature)
{
	// pduPort1 is the first device on the PDU
	// temperature is the temperature (degrees C or F): Resolution to 0.1C (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_CALLBACK
define_function pduNotifyOutletPower (dev pduOutletPort, float wattage)
{
	// pduOutletPort is the outlet on the PDU reporting its power
	// wattage is the power (W): Resolution to 0.1W (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_OUTLET_CURRENT_CALLBACK
define_function pduNotifyOutletCurrent (dev pduOutletPort, float current)
{
	// pduOutletPort is the outlet on the PDU reporting its current
	// current is the curren (A): Resolution to 0.1A (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_FACTOR_CALLBACK
define_function pduNotifyOutletPowerFactor (dev pduOutletPort, float powerFactor)
{
	// pduOutletPort is the outlet on the PDU reporting its power factor
	// powerFactor is the Power Factor: W/VA, 2 decimal places (data scale factor = 100).
	// "Power Factor" is the ratio of real power to apparent power.
}
*/

/*
#define INCLUDE_PDU_NOTIFY_OUTLET_ENERGY_CALLBACK
define_function pduNotifyOutletEnergy (dev pduOutletPort, float accumulatedEnergy)
{
	// pduOutletPort is the outlet on the PDU reporting its accumulated energy
	// accumulatedEnergy is the accumulated energy reading or power over time (W-hr): Resolution to 0.1W-hr (data scale factor = 10)
}
*/


/*
#define INCLUDE_PDU_NOTIFY_AXLINK_VOLTAGE_CALLBACK
define_function pduNotifyAxlinkVoltage (dev pduPort2, float voltage)
{
	// pduPort2 is an Axlink bus on the PDU
	// voltage is the voltage (V): Resolution to 0.1V (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_AXLINK_POWER
define_function pduNotifyAxlinkPower (dev pduAxlinkBus, float power)
{
	// pduAxlinkBus is an Axlink bus on the PDU
	// power is the power (W): Resolution to 0.1W (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_AXLINK_CURRENT
define_function pduNotifyAxlinkCurrent (dev pduAxlinkBus, float current)
{
	// pduAxlinkBus is an Axlink bus on the PDU
	// current is the current (A): Resolution to 0.1A (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_TEMPERATURE_SCALE_CELCIUS
define_function pduNotifyTemperatureScaleCelcius (dev pduPort1)
{
	// pduPort1 is the first device on the PDU
}
*/

/*
#define INCLUDE_PDU_NOTIFY_TEMPERATURE_SCALE_FAHRENHEIT
define_function pduNotifyTemperatureScaleFahrenheit (dev pduPort1)
{
	// pduPort1 is the first device on the PDU
}
*/




/*
 * --------------------
 * Events to capture responses from the PDU or update notifications
 * --------------------
 */

define_event


/*
 * --------------------
 * Data events
 * --------------------
 */


data_event[dvPduMains1]
{
	command:
	{
		stack_var char cmdHeader[50]
		
		// remove the header
		cmdHeader = pduParseCmdHeader(data.text)
		// cmdHeader contains the header
		// data.text is left with the parameters
		
		switch(cmdHeader)
		{
			#if_defined INCLUDE_PDU_NOTIFY_POWER_SENSE_TRIGGER_CALLBACK
			case PDU_RESPONSE_POWER_SENSE_TRIGGER:
			{
				stack_var integer outlet
				stack_var float triggerValue
				
				
				outlet = ATOI(data.text)
				remove_string(data.text,"'='",1)
				triggerValue = ATOF(data.text)
				
				pduNotifyPowerSenseTrigger (data.device, outlet, triggerValue)
			}
			#end_if
			
			
			#if_defined INCLUDE_PDU_NOTIFY_PHASE_ANGLE_CALLBACK
			case PDU_RESPONSE_PHASE_ANGLE:
			{
				stack_var integer outlet
				stack_var float phaseAngle
				
				outlet = ATOI(data.text)
				remove_string(data.text,"'='",1)
				phaseAngle = ATOF(data.text)
				
				pduNotifyPhaseAngle (data.device, outlet, phaseAngle)
			}
			#end_if
			
			
			#if_defined INCLUDE_PDU_NOTIFY_PERSIST_STATE_ALL_OUTLETS_CALLBACK
			case PDU_RESPONSE_PERSIST_STATE_ALL_OUTLETS:
			{
				stack_var integer outlet
				stack_var integer persistStateIndividual
				stack_var integer persistStatesAll[8]
				
				while( length_string(data.text) )
				{
					outlet = ATOI(data.text)
					remove_string(data.text,"'='",1)
					persistStateIndividual = ATOI(data.text)
					persistStatesAll[outlet] = persistStateIndividual
					if( find_string(data.text,"','",1) )
						remove_string(data.text,"','",1)
					else
						clear_buffer data.text
				}
				
				pduNotifyPersistStateAllOutlets (data.device, persistStatesAll)
			}
			#end_if
			
			#if_defined INCLUDE_PDU_NOTIFY_SERIAL_NUMBER_CALLBACK
			case PDU_RESPONSE_SERIAL_NUMBER:
			{
				stack_var char serialNumber[20]
				
				serialNumber = data.text
				
				pduNotifySerialNumber (data.device, serialNumber)
			}
			#end_if
			
			#if_defined INCLUDE_PDU_NOTIFY_VERSION_CALLBACK
			case PDU_RESPONSE_VERSION:
			{
				stack_var float version
				
				version = data.text
				
				pduNotifyVersion (data.device, version)
			}
			#end_if
			
			default:
			{
				// unhandled - do nothing!
			}
		}
	}
}

data_event[pduOutletPorts]
{
	command:
	{
		stack_var char cmdHeader[50]
		
		// remove the header
		cmdHeader = pduParseCmdHeader(data.text)
		// cmdHeader contains the header
		// data.text is left with the parameters
		
		switch(cmdHeader)
		{
			#if_defined INCLUDE_PDU_NOTIFY_OVER_CURRENT_CALLBACK
			case PDU_RESPONSE_OVER_CURRENT:
			{
				stack_var integer outlet
				stack_var float current
				
				outlet = ATOI(data.text)
				remove_string(data.text,"'='",1)
				current = ATOF(data.text)
				
				pduNotifyOverCurrent (data.device, outlet, current)
			}
			#end_if
			
			default:
			{
				// unhandled - do nothing!
			}
		}
	}
}


/*
 * --------------------
 * Channel Events
 * --------------------
 */


channel_event [pduOutletPorts, PDU_CHANNEL_POWER_SENSE]
{
	ON:
	{
		#if_defined INCLUDE_PDU_NOTIFY_OUTLET_OVER_POWER_SENSE_TRIGGER_CALLBACK
			pduNotifyOutletOverPowerSenseTrigger (channel.device)
		#end_if
	}
	OFF:
	{
		#if_defined INCLUDE_PDU_NOTIFY_OUTLET_UNDER_POWER_SENSE_TRIGGER_CALLBACK
			pduNotifyOutletUnderPowerSenseTrigger (channel.device)
		#end_if
	}
}


channel_event [pduOutletPorts, PDU_CHANNEL_POWER_RELAY]
{
	ON:
	{
		#if_defined INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
			pduNotifyOutletRelay (channel.device, TRUE)
		#end_if
	}
	OFF:
	{
		#if_defined INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
			pduNotifyOutletRelay (channel.device, FALSE)
		#end_if
	}
}

channel_event [dvPduMains1, PDU_CHANNEL_TEMP_SCALE]
{
	ON:
	{
		#if_defined INCLUDE_PDU_NOTIFY_TEMPERATURE_SCALE_FAHRENHEIT
			pduNotifyTemperatureScaleFahrenheit (channel.device)
		#end_if
	}
	OFF:
	{
		#if_defined INCLUDE_PDU_NOTIFY_TEMPERATURE_SCALE_CELCIUS
			pduNotifyTemperatureScaleCelcius (channel.device)
		#end_if
	}
}


/*
 * --------------------
 * Level events
 * --------------------
 */


// PDU Input Voltage (V)
level_event[dvPduMains1,PDU_LEVEL_INPUT_VOLTAGE]
{
	#if_defined INCLUDE_PDU_NOTIFY_INPUT_VOLTAGE_CALLBACK
		pduNotifyInputVoltage (level.input.device, (level.value / 10.0))
	#end_if
}

// Temperature reading
level_event[dvPduMains1,PDU_LEVEL_TEMPERATURE]
{
	#if_defined INCLUDE_PDU_NOTIFY_TEMPERATURE_CALLBACK
		pduNotifyTemperature (level.input.device, (level.value / 10.0))
	#end_if
}

// Power (W) for each PDU device
level_event[pduOutletPorts,PDU_LEVEL_POWER_IN_WATTS]
{
	#if_defined INCLUDE_PDU_NOTIFY_OUTLET_POWER_CALLBACK
		pduNotifyOutletPower (level.input.device, (level.value / 10.0))
	#end_if
}

// Current (A) for each PDU device
level_event[pduOutletPorts,PDU_LEVEL_CURRENT]
{
    //fPDUCurrentValues[GET_LAST(dvPDUDevices)] = level.value
	#if_defined INCLUDE_PDU_NOTIFY_OUTLET_CURRENT_CALLBACK
		pduNotifyOutletCurrent (level.input.device, (level.value / 10.0))
	#end_if
}

// Power Factor for each PDU device
level_event[pduOutletPorts,PDU_LEVEL_POWER_FACTOR]
{
    //fPDUPowerFactorValues[GET_LAST(dvPDUDevices)] = level.value
	#if_defined INCLUDE_PDU_NOTIFY_OUTLET_POWER_FACTOR_CALLBACK
		pduNotifyOutletPowerFactor (level.input.device, (level.value / 100.0))
	#end_if
}

// Energy for each PDU device
level_event[pduOutletPorts,PDU_LEVEL_ENERGY]
{
    //fPDUEnergyValues[GET_LAST(dvPDUDevices)] = level.value
	#if_defined INCLUDE_PDU_NOTIFY_OUTLET_ENERGY_CALLBACK
		pduNotifyOutletEnergy (level.input.device, (level.value / 10.0))
	#end_if
}

// Axlink Voltage (V)
level_event[dvPduMains2,PDU_LEVEL_AXLINK_VOLTAGE]
{
    //fPDUAxLinkVoltage = level.value
	#if_defined INCLUDE_PDU_NOTIFY_AXLINK_VOLTAGE_CALLBACK
		pduNotifyAxlinkVoltage (level.input.device, (level.value / 10.0))
	#end_if
}

// Axlink 1 Power (W)
level_event[dvPduAxlinkBuses,PDU_LEVEL_AXLINK_POWER]
{
    //fPDUAxLinkPowerValues[1] = level.value
	#if_defined INCLUDE_PDU_NOTIFY_AXLINK_POWER
		pduNotifyAxlinkPower (level.input.device, (level.value / 10.0))
	#end_if
}

// Axlink 1 Current (A)
level_event[dvPduAxlinkBuses,PDU_LEVEL_AXLINK_CURRENT]
{
    //fPDUAxLinkCurrentValues[1] = level.value
	#if_defined INCLUDE_PDU_NOTIFY_AXLINK_CURRENT
		pduNotifyAxlinkCurrent (level.input.device, (level.value / 10.0))
	#end_if
}

#end_if