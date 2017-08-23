//---[ USER Customizable Parameters ]-----------------------------------------

/* [General] */

// Part to generate
part = 3;// [0:Base,1:Pcb cover,2:Label cover,3:All,4:Assembled]

// Tickness of the base
base_thickness_mm = 3; //[0.1:10]

// Tickness of the pcb with the connectors
pcb_thickness_mm = 1.60; //[0.1:10]

// Tickness of the layer of plastic on top of the pcb
pcb_cover_thickness_mm = 1.60; //[0.1:10]

// Separator between connections side and labels
separator_thickness_mm = 2;

/* [Connectors side] */

// Number of pins
number_of_pins = 10; //[1:50]

// Number of rows of pins
number_of_rows = 10; //[1:50]

// Separation between rows (in pin width)
rows_in_between = 2; //[1:10]

// Horizontal separation between sides (in pin width)
rows_extra_horizontal = 1; //[1:10]

// Vertical separation between sides (in pin width)
rows_extra_vertical = 1; //[1:10]

/* [Labelling side] */

// Label length (in mm)
label_length_mm = 40; //[1:10]

// Label margin (in mm)
label_margin = 1;  //[0:100]

//----------------------------------------------------------------------------

distance_between_pins_mm = 2.49;
slider_holder_angle_ratio_percent = 50; // Percent of pcb_cover_thickness_mm. This changes the angle for holding the cover 
cover_rim_mm = 2;

//----------------------------------------------------------------------------

connectors_base_width = (number_of_rows*(1+rows_in_between)+rows_extra_horizontal*2) * distance_between_pins_mm;
connectors_base_length = (number_of_pins+rows_extra_vertical*2) * distance_between_pins_mm;

module holder(length)
{
  rotate([90,0,0])
    linear_extrude(length)  
      polygon([
      [0,0],
      [0,pcb_thickness_mm+pcb_cover_thickness_mm],
      [rows_extra_horizontal*distance_between_pins_mm+(pcb_cover_thickness_mm/100*slider_holder_angle_ratio_percent),pcb_thickness_mm+pcb_cover_thickness_mm],
      [rows_extra_horizontal*distance_between_pins_mm,pcb_thickness_mm],
      [rows_extra_horizontal*distance_between_pins_mm,0],
      ]);
}

module base()
{
  union() 
  {
    cube([connectors_base_width,connectors_base_length+label_length_mm+separator_thickness_mm,base_thickness_mm]);
    
    // Separator
    translate([0,connectors_base_length,base_thickness_mm])
      cube([connectors_base_width,separator_thickness_mm,pcb_cover_thickness_mm+pcb_thickness_mm]);
      
    // Holder for the PCB
    translate([0,connectors_base_length,base_thickness_mm])
        holder(connectors_base_length);
    
    translate([connectors_base_width,0,base_thickness_mm])    
      rotate([0,0,180])   
        holder(connectors_base_length);
      
    // Holder for the labels
    translate([0,connectors_base_length+label_length_mm+separator_thickness_mm,base_thickness_mm])
      holder(label_length_mm); 
      
    translate([connectors_base_width,connectors_base_length+separator_thickness_mm,base_thickness_mm])
      rotate([0,0,180])  
        holder(label_length_mm); 
  }
}

module cover(length,margin)
{
  rotate([180,0,0]) // Just to flip it for printing
    union()
    {
    /*translate([rows_extra_horizontal*2,0,0])
      cube([connectors_base_width-rows_extra_horizontal*2*distance_between_pins_mm,cover_rim_mm,cover_rim_mm]);*/
      difference()
      {
        rotate([90,0,0])
          linear_extrude(length)  
            polygon([
            [rows_extra_horizontal*distance_between_pins_mm+(pcb_cover_thickness_mm/100*slider_holder_angle_ratio_percent),pcb_cover_thickness_mm],
            [rows_extra_horizontal*distance_between_pins_mm,0],
            [connectors_base_width-rows_extra_horizontal*distance_between_pins_mm,0],
            [(pcb_cover_thickness_mm/100*-slider_holder_angle_ratio_percent)+connectors_base_width-rows_extra_horizontal*distance_between_pins_mm,pcb_cover_thickness_mm],
            ]);
         
        // Holes for the pins/labels
        translate([-rows_extra_horizontal*distance_between_pins_mm-margin,-length+rows_extra_vertical*distance_between_pins_mm-margin,-1])
        for(i=[0:number_of_rows])
          translate([(1+rows_in_between)*distance_between_pins_mm*i,0,0])
            cube([distance_between_pins_mm+margin*2,length-(2*rows_extra_horizontal*distance_between_pins_mm)+margin*2,pcb_thickness_mm+2]);
      } 
    }
}

module pcb_cover()
{
  cover(connectors_base_length,0);
}

module label_cover()
{
  cover(label_length_mm,label_margin);
}

// ----------------------------------------------------

// Let's draw!

// Base only
if(part==0)
  base();

// Pcb Cover
if(part==1)
  pcb_cover();
  
// Label Cover
if(part==2)
  label_cover();
  
// All parts (ready to print)
if(part==3)
{
  base();
  

  translate([0,-1-connectors_base_length,pcb_cover_thickness_mm])
    pcb_cover();
  
  translate([0,-2-connectors_base_length-label_length_mm,pcb_cover_thickness_mm])
  label_cover();
} 

// Assembled
if(part==4)
{
  color("blue")
    base();
  
  color("red")
    translate([0,connectors_base_length,base_thickness_mm+pcb_thickness_mm])
      rotate([180,0,0]) // Turn it over, we are not printing
        pcb_cover();
  
  color("green")
  translate([0,connectors_base_length+label_length_mm+separator_thickness_mm,base_thickness_mm+pcb_thickness_mm])
  rotate([180,0,0]) // Turn it over, we are not printing
  label_cover();
} 