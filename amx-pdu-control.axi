PROGRAM_NAME='amx-pdu-control'

#if_not_defined __AMX_PDU_CONTROL__
#define __AMX_PDU_CONTROL__

/*
 * --------------------
 * amx-pdu-control
 *
 * For usage, check out the readme for the amx-pdu-library.
 * --------------------
 */

define_constant

char VERSION_AMX_PDU_CONTROL[] = 'v1.0.0'

#include 'amx-pdu-api'
#include 'amx-device-control'


/*
 * --------------------
 * Function Naming Format
 * 
 * pduRequestXXXXXXXX
 *  - call the pduRequest functions to request information from a DVX.
 * 
 * pduSetXXXXXXX
 *  - call the pduSet functions to set a value on a PDU.
 * 
 * pduEnableXXXXXXX
 * - call the pduEnable functions to enable a setting on the PDU which can be enabled or disabled.
 * 
 * pduDisableXXXXXXX
 *  - call the pduDisable functions to disable a setting on the PDU which can be enabled or disabled.
 * 
 * pduToggleXXXXXX
 * - call the pduCycle functions to toggle a setting on the PDU from enabled to disabled or vice versa.
 * --------------------
 */


/*
 * --------------------
 * Temperature functions
 * --------------------
 */


/*
 * Function:	pduSetTempScaleCelcius
 * 
 * Arguments:	dev pduPort1 - port 1 on the PDU
 * 
 * Description:	Sets temperature scale on the PDU to Celcius Degrees.
 */
define_function pduSetTempScaleCelcius (dev pduPort1)
{
    channelOff (pduPort1,PDU_CHANNEL_TEMP_SCALE)
}

/*
 * Function:	pduSetTempScaleFarenheit
 * 
 * Arguments:	dev pduPort1 - port 1 on the PDU
 * 
 * Description:	Sets temperature scale on the PDU to Farenheit Degrees.
 */
define_function pduSetTempScaleFahrenheit (dev pduPort1)
{
    channelOn (pduPort1,PDU_CHANNEL_TEMP_SCALE)
}


/*
 * --------------------
 * Relay functions
 * --------------------
 */


/*
 * Function:	pduEnableRelayPower
 * 
 * Arguments:	dev pduOutletPort - outlet port on the PDU
 * 
 * Description:	Enable PDU Power Outlet Relay.
 */
define_function pduEnableRelayPower (dev pduOutletPort)
{
	channelOn (pduOutletPort,PDU_CHANNEL_POWER_RELAY)
}

/*
 * Function:	pduDisableRelayPower
 * 
 * Arguments:	dev pduOutletPort - outlet port on the PDU
 * 
 * Description:	Disable PDU Power Outlet Relay.
 */
define_function pduDisableRelayPower (dev pduOutletPort)
{
	channelOff (pduOutletPort,PDU_CHANNEL_POWER_RELAY)
}

/*
 * Function:	pduToggleRelayPower
 * 
 * Arguments:	dev pduOutletPort - outlet port on the PDU
 * 
 * Description:	Toggle PDU Power Outlet Relay.
 */
define_function pduToggleRelayPower (dev pduOutletPort)
{
	channelToggle(pduOutletPort,PDU_CHANNEL_POWER_RELAY)
}

/*
 * Function:	pduRequestPersistStateAllOutlets
 * 
 * Arguments:	dev pduPort1 - port 1 device on the PDU
 * 
 * Description:	Request Persist State of all outlets on PDU.
 */
define_function pduRequestPersistStateAllOutlets (dev pduPort1)
{
	sendCommand (pduPort1, "PDU_COMMAND_PERSIST_STATE_ALL_OUTLETS_REQUEST")
}


/*
 * --------------------
 * Trigger Sense functions
 * --------------------
 */


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

/*
 * Function:	pduRequestPowerTriggerSenseValue
 * 
 * Arguments:	dev pduPort1 - port 1 device on the PDU
 *				integer outlet - outlet port on the PDU
 * 
 * Description:	Request Trigger Sense Value of PDU Power Outlet.
 */
define_function pduRequestPowerTriggerSenseValue (dev pduPort1, integer outlet)
{
	sendCommand (pduPort1, "PDU_COMMAND_POWER_SENSE_TRIGGER_REQUEST,itoa(outlet)")
}


/*
 * --------------------
 * Phase Angle functions
 * --------------------
 */


/*
 * Function:	pduRequestPhaseAngle
 * 
 * Arguments:	dev pduPort1 - port 1 device on the PDU
 * 
 * Description:	Request Phase Angle on PDU.
 */
define_function pduRequestPhaseAngle (dev pduPort1)
{
	sendCommand (pduPort1, "PDU_COMMAND_PHASE_ANGLE_REQUEST")
}


/*
 * --------------------
 * Reset functions
 * --------------------
 */


/*
 * Function:	pduResetAccumulatedEnergyReading
 * 
 * Arguments:	dev dvPduOutlet - Outlet device on the PDU
 * 
 * Description:	Reset the accumulated energy reading for a PDU outlet.
 */
define_function pduResetAccumulatedEnergyReading (dev dvPduOutlet)
{
	sendLevel (dvPduOutlet, PDU_LEVEL_ENERGY, 0)
}

/*
 * Function:	pduFactoryReset
 * 
 * Arguments:	dev pduPort1 - port 1 device on the PDU
 * 
 * Description:	Restores all settings on the PDU to the factory default settings.
 */
define_function pduFactoryReset (dev pduPort1)
{
	sendCommand (pduPort1, "PDU_COMMAND_FACTORY_RESET")
}

/*
 * Function:	pduReset
 * 
 * Arguments:	dev pduPort1 - port 1 device on the PDU
 * 
 * Description:	Triggers a Power-On-Reset of the PDU. Toggles all interruptible power outlets.
 */
define_function pduResetOutlet (dev pduPort1)
{
	sendCommand (pduPort1, "PDU_COMMAND_RESET")
}


/*
 * --------------------
 * Information Request functions
 * --------------------
 */


/*
 * Function:	pduRequestVersion
 * 
 * Arguments:	dev pduPort1 - port 1 device on the PDU
 * 
 * Description:	Request FW version of PDU.
 */
define_function pduRequestVersion (dev pduPort1)
{
	sendCommand (pduPort1, "PDU_COMMAND_VERSION_REQUEST")
}

/*
 * Function:	pduRequestSerialNumber
 * 
 * Arguments:	dev pduPort1 - port 1 device on the PDU
 * 
 * Description:	Request PDU Serial Number.
 */
define_function pduRequestSerialNumber (dev pduPort1)
{
	sendCommand (pduPort1, "PDU_COMMAND_SERIAL_NUMBER_REQUEST")
}

#end_if