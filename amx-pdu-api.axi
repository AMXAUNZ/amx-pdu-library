PROGRAM_NAME='amx-pdu-api'

#if_not_defined __AMX_PDU_API__
#define __AMX_PDU_API__

/*
 * --------------------
 * amx-pdu-api
 *
 * For usage, check out the readme for the amx-pdu-library.
 * --------------------
 */

define_constant

char VERSION_AMX_PDU_API[] = 'v1.0.0'


define_type


/*
 * --------------------
 * PDU structures
 * 
 * Can be used by NetLinx programmer to keep track of PDU info.
 * --------------------
 */


structure _PduValues
{
	INTEGER relaysStatus[8]
	INTEGER powerSenseStatus[8]		// value of 0 means sensed power is below specified trigger level, value of 1 means sensed power is above specified trigger level
	FLOAT powerValues[8]
	FLOAT currentValues[8]
	FLOAT powerFactorValues[8]
	FLOAT energyValues[8]
	FLOAT inputVoltage
	FLOAT axLinkVoltage
	FLOAT axLinkPowerValues[2]
	FLOAT axLinkCurrentValues[2]
	FLOAT temperature
	INTEGER outletPersistStates[8]
	FLOAT triggerValues[8]
	FLOAT phaseAngles[8]
	FLOAT version
}

define_constant


/*
 * --------------------
 * PDU channel codes
 * --------------------
 */


integer PDU_CHANNEL_POWER_RELAY			=	1	// applies to all 8 devices (Used for control and status)
integer PDU_CHANNEL_TEMP_SCALE			=	2	// (OFF=Celcius, ON=Farenheit) - applies only to 1st device
integer PDU_CHANNEL_AXLINK_POWER_RELAY	=	3	// applies only to device 1 and 2
integer PDU_CHANNEL_POWER_SENSE			=	255	// applies to all 8 devices
						// Signals that power (in watts) is above or below the specified trigger level (set via the TRIGGER command)


/*
 * --------------------
 * PDU level codes
 * --------------------
 */


integer PDU_LEVEL_POWER_IN_WATTS	=	1	// applies to all 8 devices - Power (W), resolution to 0.1W (data scale factor=10)
integer PDU_LEVEL_CURRENT			=	2	// applies to all 8 devices - Current (A), resolution to 0.1A (data scale factor=10)
integer PDU_LEVEL_POWER_FACTOR		=	3	// applies to all 8 devices - Power Factor (W/VA), 2 decimal places (data scale factor = 100)
integer PDU_LEVEL_ENERGY			=	4	// applies to all 8 devices - Energy (W-hr), Power over time, resolution to 0.1W-hr (Data scale factor = 10, writing 0 resets counter)
integer PDU_LEVEL_INPUT_VOLTAGE		=	5	// Input voltage - applies only to 1st device
integer PDU_LEVEL_AXLINK_VOLTAGE	=	5	// AxLink voltage - applies only to 2nd device
integer PDU_LEVEL_AXLINK_POWER		=	6	// AxLink 1 power - applies only to 1st & 2nd devices
integer PDU_LEVEL_AXLINK_CURRENT	=	7	// AxLink 1 current - applies only to 1st & 2nd devicess
integer PDU_LEVEL_TEMPERATURE		=	8	// Temperature sensor - applies only to 1st device


/*
 * --------------------
 * PDU command headers
 * --------------------
 */


char PDU_COMMAND_FACTORY_RESET[]						= 'ZAP!'
char PDU_COMMAND_PERSIST_STATE_ALL_OUTLETS_REQUEST[]	= '?PERSIST'
char PDU_COMMAND_PHASE_ANGLE_REQUEST[]					= '?PHASEANGLE-'
char PDU_COMMAND_POWER_SENSE_TRIGGER[]					= 'TRIGGER-'
char PDU_COMMAND_POWER_SENSE_TRIGGER_REQUEST[]			= '?TRIGGER-'
char PDU_COMMAND_RESET[]								= 'RESET'
char PDU_COMMAND_SERIAL_NUMBER_REQUEST[]				= '?SERIAL'
char PDU_COMMAND_VERSION_REQUEST[]						= 'VER'

// Response Headers
char PDU_RESPONSE_OVER_CURRENT[]				= 'OVERCURRENT-'
char PDU_RESPONSE_PERSIST_STATE_ALL_OUTLETS[]	= 'PERSIST-'
char PDU_RESPONSE_POWER_SENSE_TRIGGER[]			= 'TRIGGER-'
char PDU_RESPONSE_PHASE_ANGLE[]					= 'PHASEANGLE-'
char PDU_RESPONSE_SERIAL_NUMBER[]				= 'SERIAL '
char PDU_RESPONSE_VERSION[]						= 'V'

/*
 * --------------------
 * PDU outlets
 * --------------------
 */


integer PDU_MAX_OUTLETS = 8

integer PDU_OUTLET_1	=	1
integer PDU_OUTLET_2	=	2
integer PDU_OUTLET_3	=	3
integer PDU_OUTLET_4	=	4
integer PDU_OUTLET_5	=	5
integer PDU_OUTLET_6	=	6
integer PDU_OUTLET_7	=	7
integer PDU_OUTLET_8	=	8


/*
 * --------------------
 * Functions to parse return comamands from PDU
 * --------------------
 */


define_constant

char cPduCmdHeaderSeperator[] = '-'
char cPduCmdParamaterSeperator[] = ','

// Name   : ==== PduParseCmdHeader ====
// Purpose: To parse out parameters from PDU send_command or send_string
// Params : (1) IN/OUT  - sndcmd/str data
// Returns: parsed property/method name, still includes the leading '?' and/or trailing command seperating caharacter if present
// Notes  : Parses the strings sent to or from modules extracting the command header.
//          Command separating character assumed to be '-'
//
define_function char[100] pduParseCmdHeader(CHAR cCmd[])
{
	stack_var char cCmdHeader[100]
  	
	// Special case #1 is the response to the version request. It does not seperate the header from the data by the typical seperator
	if( find_string(cCmd,PDU_RESPONSE_VERSION,1) == 1)
	{
		cCmdHeader = remove_string(cCmd,PDU_RESPONSE_VERSION,1)
	}
	// Special case #1 is the response to the serial number request. It does not seperate the header from the data by the typical seperator
	else if( find_string(cCmd,PDU_RESPONSE_SERIAL_NUMBER,1) == 1)
	{
		cCmdHeader = remove_string(cCmd,PDU_RESPONSE_SERIAL_NUMBER,1)
	}
	else
	{
		cCmdHeader = remove_string(cCmd,cPduCmdHeaderSeperator,1)
	}
	
	return cCmdHeader
}

// Name   : ==== pduParseCmdParam ====
// Purpose: To parse out parameters from received PDU send_command or send_string
// Params : (1) IN/OUT  - sndcmd/str data
// Returns: Parse parameter from the front of the string not including the separator
// Notes  : Parses the strings sent to or from modules extracting the parameters.
//          A single param is picked of the cmd string and removed, through the separator.
//          The separator is NOT returned from the function.
//          If the first character of the param is a double quote, the function will 
//          remove up to (and including) the next double-quote and the separator without spaces.
//          The double quotes will then be stripped from the parameter before it is returned.
//          If the double-quote/separator sequence is not found, the function will remove up to (and including)
//          the separator character and the leading double quote will NOT be removed.
//          If the separator is not found, the entire remained of the command is removed.
//          Parameter separating character assumed to be ','
//
define_function char[100] pduParseCmdParam(CHAR cCmd[])
{
    stack_var char cTemp[100]
    stack_var char cSep[1]
    stack_var char chC
    stack_var integer nLoop
    stack_var integer nState
    stack_var char bInquotes
    stack_var char bDone

    
    // Reset state
    nState = 1; //ST_START
    bInquotes = FALSE;
    bDone = FALSE;

    // Loop the command and escape it
    for (nLoop = 1; nLoop <= length_array(cCmd); nLoop++)
    {
	// Grab characters and process it based on state machine
	chC = cCmd[nLoop];
	switch (nState)
	{
	    // Start or string: end of string bails us out
	    case 1: //ST_START
	    {
		// Starts with a quote?
		// If so, skip it, set flag and move to collect.
		if (chC == '"')
		{
		    nState = 2; //ST_COLLECT
		    bInquotes = TRUE;
		}
		
		// Starts with a comma?  Empty param
		else if (chC == cPduCmdParamaterSeperator)
		{
		    // I am done
		    bDone = TRUE;
		}
		
		// Not a quote or a comma?  Add it to the string and move to collection
		else
		{
		    cTemp = "cTemp, chC"
		    nState = 2; //ST_COLLECT
		}
		break;
	    }
	    
	    // Collect string.
	    case 2: //ST_COLLECT
	    {
		// If in quotes, just grab the characters
		if (bInquotes)
		{
		    // Ah...found a quote, jump to end quote state
		    if (chC == '"' )
		    {
			nState = 3; //ST_END_QUOTE
			break;
		    }
		}
		
		// Not in quotes, look for commas
		else if (chC == cPduCmdParamaterSeperator)
		{
		    // I am done
		    bDone = TRUE;
		    break;
		}
		
		// Not in quotes, look for quotes (this would be wrong)
		// But instead of barfing, I will just add the quote (below)
		else if (chC == '"' )
		{
		    // I will check to see if it should be escaped
		    if (nLoop < length_array(cCmd))
		    {
			// If this is 2 uqotes back to back, just include the one
			if (cCmd[nLoop+1] = '"')
			    nLoop++;
		    }
		}
		
		// Add character to collection
		cTemp = "cTemp,chC"
		break;
	    }
	    
	    // End Quote
	    case 3: //ST_END_QUOTE
	    {
		// Hit a comma
		if (chC == cPduCmdParamaterSeperator)
		{
		    // I am done
		    bDone = TRUE;
		}
		
		// OK, found a quote right after another quote.  So this is escaped.
		else if (chC == '"')
		{
		    cTemp = "cTemp,chC"
		    nState = 2; //ST_COLLECT
		}
		break;
	    }
	}

	// OK, if end of string or done, process and exit
	IF (bDone == TRUE || nLoop >= length_array(cCmd))
	{
	    // remove cTemp from cCmd
	    cCmd = mid_string(cCmd, nLoop + 1, length_string(cCmd) - nLoop)
	    
	    // cTemp is done
	    return cTemp;
	}
    }

  // Well...we should never hit this
  return "";
}

#end_if