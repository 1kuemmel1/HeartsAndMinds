params [
    ["_random", 0, [0]],
    ["_active_city", objNull, [objNull]],
    ["_area", btc_patrol_area, [0]]
];

if (isNil "btc_patrol_id") then {btc_patrol_id = 0;};

if (_random isEqualTo 0) then {
    _random = selectRandom [1, 2];
};

if (btc_debug_log) then {
    [format ["_random = %1 _active_city %2 _area %3 btc_patrol_active = %4", _random, _active_city, _area, count btc_patrol_active], __FILE__, [false]] call btc_fnc_debug_message;
};

sleep 5 + random 10;
//Remove if too far from player
if ([_active_city, grpNull, _area] call btc_fnc_playersInAreaCityGroup) exitWith {false};

//Find a city
private _cities = btc_city_all inAreaArray [getPosWorld _active_city, _area, _area];
private _usefuls = _cities select {!(_x getVariable ["active", false]) && _x getVariable ["occupied", false]};
if (_usefuls isEqualTo []) exitWith {false};

//Randomize position if city has a beach so position could be in water
private _start_city = selectRandom _usefuls;
private _pos = [];
if (_start_city getVariable ["hasbeach", false]) then {
    _pos = [getPos _start_city, (_start_city getVariable ["RadiusX", 0]) + (_start_city getVariable ["RadiusY", 0]), btc_p_sea] call btc_fnc_randomize_pos;
} else {
    _pos = getPos _start_city;
};
private _pos_isWater = surfaceIsWater _pos;
if (_pos_isWater) then {
    _random = 2;
};

//Creating units
private _group = createGroup [btc_enemy_side, true];
_group setVariable ["no_cache", true];
_group setVariable ["btc_patrol_id", btc_patrol_id, btc_debug];
btc_patrol_id = btc_patrol_id + 1;

switch (true) do {
    case (_random isEqualTo 1) : {
        private _n_units = 5 + (round random 8);
        _pos = [_pos, 0, 50, 10, false] call btc_fnc_findsafepos;

        [_group, _pos, _n_units] call btc_fnc_mil_createUnits;
    };
    case (_random isEqualTo 2) : {
        private _veh_type = "";
        if (_pos_isWater) then {
            _veh_type = selectRandom btc_type_boats;
        } else {
            _veh_type = selectRandom (btc_type_motorized + [selectRandom btc_civ_type_veh]);
            //Tweak position of spawn
            private _roads = _pos nearRoads 150;
            if (_roads isEqualTo []) then {
                _pos = [_pos, 0, 500, 13, false] call btc_fnc_findsafepos;
            } else {
                _pos = getPos selectRandom _roads;
            };
        };
        private _veh = [_group, _pos, _veh_type] call btc_fnc_mil_createVehicle;

        private _1 = _veh addEventHandler ["Fuel", btc_fnc_mil_patrol_eh];
        _veh setVariable ["eh", [_1/*, _2, _3,4, 5*/]];
        _veh setVariable ["btc_crews", _group];
    };
};

[_group, [_start_city, _active_city], _area, _pos_isWater] call btc_fnc_mil_patrol_init;

btc_patrol_active pushBack _group;

//Check if HC is connected
if !((entities "HeadlessClient_F") isEqualTo []) then {
    [_group] call btc_fnc_set_groupowner;
};

true
