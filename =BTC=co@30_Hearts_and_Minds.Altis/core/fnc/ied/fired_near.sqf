params ["_wreck", "_ied"];

(getPos _ied) params ["_x", "_y", "_z"];
private _pos = [_x, _y, _z + 0.5];
private _range = 2;

_array = [];
[{
    params ["_args", "_id"];
    _args params ["_ied", "_wreck", "_pos", "_range", "_array"];

    if (Alive _ied && !isNull _ied) then {
        private _list = _pos nearObjects ["Default", _range];
        if !(_list isEqualTo []) then {
            {
                private _b = _x;
                private _bullet = typeOf _b;
                if ({_bullet isKindOf _x} count ["SmokeShell", "FlareCore", "IRStrobeBase", "GrenadeHand_stone", "Smoke_120mm_AMOS_White", "TMR_R_DG32V_F"] > 0) exitWith {};
                if ({_bullet isKindOf _x} count ["TimeBombCore", "BombCore", "Grenade"] > 0) then {
                    if !(_b in _array) then {
                        _array pushBack _b;
                        [{!Alive _b}, {
                            params ["_wreck", "_ied"];

                            if (Alive _ied) then {[_wreck, _ied] call btc_fnc_ied_boom;};
                        }, [_wreck, _ied]] call CBA_fnc_waitUntilAndExecute;
                    };
                } else {
                    private _explosive = getNumber(configFile >> "cfgAmmo" >> _bullet >> "explosive") > 0;
                    private _caliber = getNumber(configFile >> "CfgAmmo" >> _bullet >> "caliber");
                    if (_explosive || _caliber > 1.6) then {
                        if (Alive _ied) then {
                            [_wreck, _ied] call btc_fnc_ied_boom;
                        };
                    };
                };
            } forEach _list;
        };
    } else {
        [_id] call CBA_fnc_removePerFrameHandler;
    };
} , 0.01, [_ied, _wreck, _pos, _range, _array]] call CBA_fnc_addPerFrameHandler;