/* ----------------------------------------------------------------------------
Function: CBA_fnc_keyHandler
---------------------------------------------------------------------------- */
#include "script_component.hpp"
SCRIPT(keyHandler);

private ["_settings", "_code", "_handled", "_result"];
#ifdef DEBUG
	private ["_ar"];
	_ar = [];
#endif

_handled = false; // If true, suppress the default handling of the key.
_result = false;

{
	_settings = _x select 0;
	_code = _x select 1;
	if (true) then
	{
		if (_settings select 0 && !(_this select 2)) exitWith {};
		if (_settings select 1 && !(_this select 3)) exitWith {};
		if (_settings select 2 && !(_this select 4)) exitWith {};
		if (!(_settings select 0) && _this select 2) exitWith {};
		if (!(_settings select 1) && _this select 3) exitWith {};
		if (!(_settings select 2) && _this select 4) exitWith {};
		#ifdef DEBUG
			PUSH(_ar,_code);
		#endif
		_result = _this call _code;
		
		if (isNil "_result") then
		{
			WARNING("Nil result from handler.");
			_result = false;
		}
		else{if ((typeName _result) != "BOOL") then
		{
			TRACE_1("WARNING: Non-boolean result from handler.",_result);
			_result = false;
		}; };
	};
	
	// If any handler says that it has completely _handled_ the keypress,
	// then don't allow other handlers to be tried at all.
	if (_result) exitWith { _handled = true };
	
} forEach (GVAR(keys) select (_this select 1));
#ifdef DEBUG
	if (count _ar > 0) then
	{
		[format["KeyPressed: %1, Executing: %2", _this, _ar], QUOTE(ADDON)] call CBA_fDebug;
	} else {
		[format["KeyPressed: %1, No Execution", _this], QUOTE(ADDON)] call CBA_fDebug;
	};
#endif

_handled;
