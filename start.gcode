; material_type = [filament_type[initial_tool]]
; material_vendor = [filament_vendor[initial_tool]]
; material_preset = [filament_preset]
; print_preset = [print_preset]
; plate_name = [plate_name]
; input_filename_base = [input_filename_base]
; datetime = [year]-[month]-[day] [hour]:[minute]:[second]
; timestamp = [timestamp]
; build_volume_temperature = [overall_chamber_temperature]

G90 ; use absolute coordinates
M83 ; extruder relative mode

; Preheat
M117 Preheating... ; display message
M140 S[bed_temperature_initial_layer] ; set final bed temp
M104 S150 ; set temporary nozzle temp to prevent oozing during homing


; Prehoming - While the bed is heating, move head into position close to the bed
M117 Clearing Z of bed... ; display message
G91 ; Switch to relative coordinates
G1 Z30.0 F3000 ; Move up 2cm to avoid crashing head
G90 ; Switch back to absolute coordinates

M117 Homing... ; display message
M280 P0 S160 ; BLTouch alarm release
G4 P100 ; delay for BLTouch
G28 ; Home all axes

M117 Bed heating...
M190 S[bed_temperature_initial_layer] ; wait for bed temp to stabilize

; UBL Mesh tilting
M117 Tilting mesh... ; display message
G29 A ; Activate the UBL System.
G29 L0 ; Load UBL
G29 J2 ; 4-point level
{if first_layer_print_min[0] < print_bed_size[0]/2 - 70 or first_layer_print_min[1] < print_bed_size[1]/2 - 70 or first_layer_print_max[0] > print_bed_size[0]/2 + 70 or first_layer_print_max[1] > print_bed_size[1]/2 + 70}
M117 Outside safe area. Fade 10mm ; display message
G29 F10.0 ; Print outside safe area, fade to 10mm
{else}
M117 Inside safe area. Fade 5mm ; display message
G29 F5 ; Print inside safe area, fade to 5mm
{endif}

M117 Moving to priming position... ; display message
G1 Z2.0 F3000 ; Move Z Axis up to prevent scratching the bed
G1 X235 Y5 F3000 ; Move to nozzle priming position

; Heating
M117 Heating to initial temperatures... ; display message
M104 S[nozzle_temperature_initial_layer] ; set final nozzle temp
M109 S[nozzle_temperature_initial_layer] ; wait for nozzle temp to stabilize

; Nozzle priming sequence
M117 Priming nozzle... ; display message
G1 Z0.28 F240
G92 E0
G1 E30 F500 ; prime the nozzle next to the bed
G4 P1000 ; wait for squeeze out
G1 X220 Y5 F3000 ; wipe the string on the side of the buildplate
G1 Z2.0 F3000 ; Move Z Axis up to prevent scratching the bed
G92 E0

M117 Printing... ; display message
