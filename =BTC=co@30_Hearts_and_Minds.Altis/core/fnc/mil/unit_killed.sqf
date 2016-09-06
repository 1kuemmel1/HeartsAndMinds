
private ["_killer"];

_killer = (_this select 0) getVariable ["ace_medical_lastDamageSource", (_this select 1)];

if (!isDedicated && !hasInterface) then {
	[(_this select 0), _killer] remoteExec ["btc_fnc_mil_unit_killed",2];
} else {
	if (random 100 > btc_info_intel_chance) then {
		(_this select 0) setVariable ["intel",true];
	};

	if (isPlayer _killer) then {
		if (isServer) then {
			btc_rep_bonus_mil_killed call btc_fnc_rep_change;
		} else {
			[btc_rep_bonus_mil_killed,"btc_fnc_rep_change",false] spawn BIS_fnc_MP;
		};
	};
};

//(_this select 0) spawn {sleep 0.5;{deleteVehicle _x} foreach (nearestObjects [_this, ["WeaponHolderSimulated"], 5]);};