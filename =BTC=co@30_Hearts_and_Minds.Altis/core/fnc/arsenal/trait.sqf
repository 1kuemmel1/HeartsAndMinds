params [
    ["_player", objNull, [objNull]]
];

// 0 - Rifleman, 1 - Medic Adv, 2 - Medic Basic, 3 - Repair, 4 - Engineer, 5 - Anti-Tank, 6 - Anti Air, 7 - Sniper, 8 - Machine gunner
// https://community.bistudio.com/wiki/CfgAmmo_Config_Reference#aiAmmoUsageFlags
private _type_ammoUsageAllowed = [];
switch (true) do {
    case ((_player getUnitTrait "medic") && (ace_medical_level isEqualTo 1)): {
        _type_ammoUsageAllowed = [1, [["AssaultRifle", "", [false, "Rifle_Long_Base_F"]]]];
    };
    case ((_player getUnitTrait "medic") && (ace_medical_level isEqualTo 2)): {
        _type_ammoUsageAllowed = [2, [["AssaultRifle", "", [false, "Rifle_Long_Base_F"]]]];
    };
    case (_player getVariable ["ace_isEngineer", 0] in [1, 2]): {
        _type_ammoUsageAllowed = [3, [["AssaultRifle", "", [false, "Rifle_Long_Base_F"]]]];
    };
    case (_player getUnitTrait "explosiveSpecialist"): {
        _type_ammoUsageAllowed = [4, [["AssaultRifle", "", [false, "Rifle_Long_Base_F"]]]];
    };
    case ([typeOf _player, ["MissileLauncher", "128 + 512"]] call btc_fnc_mil_ammoUsage): {
        _type_ammoUsageAllowed = [5, [["AssaultRifle", "", [false, "Rifle_Long_Base_F"]], ["RocketLauncher", ""], ["MissileLauncher",  "128 + 512"]]];
    };
    case ([typeOf _player, ["MissileLauncher", "256"]] call btc_fnc_mil_ammoUsage): {
        _type_ammoUsageAllowed = [6, [["AssaultRifle", "", [false, "Rifle_Long_Base_F"]], ["MissileLauncher", "256"]]];
    };
    case ([typeOf _player, ["SniperRifle", ""]] call btc_fnc_mil_ammoUsage): {
        _type_ammoUsageAllowed = [7, [["AssaultRifle", "64 + 128 + 256", [true, "Rifle_Long_Base_F"]], ["SniperRifle", ""]]];
    };
    case ([typeOf _player, ["MachineGun", ""]] call btc_fnc_mil_ammoUsage): {
        _type_ammoUsageAllowed = [8, [["MachineGun", ""]]];
    };
    default {
        _type_ammoUsageAllowed = [0, [["AssaultRifle", "", [false, "Rifle_Long_Base_F"]], ["RocketLauncher", ""]]];
    };
};

if (btc_debug || btc_debug_log) then {
    [
        format ["IsMedic basic: %1 IsMedic Adv: %2 IsAdvEngineer: %3 IsExplosiveSpecialist: %4 IsAT: %5 IsAA: %6",
            (_player getUnitTrait "medic") && (ace_medical_level isEqualTo 1),
            (_player getUnitTrait "medic") && (ace_medical_level isEqualTo 2),
            _player getVariable ["ace_isEngineer", 0],
            _player getUnitTrait "explosiveSpecialist",
            [typeOf _player, ["MissileLauncher", "128 + 512"]] call btc_fnc_mil_ammoUsage,
            [typeOf _player, ["MissileLauncher", "256"]] call btc_fnc_mil_ammoUsage
        ], __FILE__, [btc_debug, btc_debug_log]
    ] call btc_fnc_debug_message;
};

_type_ammoUsageAllowed