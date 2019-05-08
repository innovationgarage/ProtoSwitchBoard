content = "Matteo 79";
font="Makisupa:style=Regular";
size=5;
halign="center";

union(){
    rotate([270,0,90])
        import("protoswitchboard_cover_1.stl");

    // The two labels
    translate([-44.5,-85,2])
    {
        translate([0,85,0])
        rotate([90,0,270])
        drawLabel();
    }
}

module drawLabel()
{
    /*union(){
    translate([0,0,0.3])
    linear_extrude(0.5)
        offset(0.5)
            text(content,font=font,size=size,halign=halign);*/

    linear_extrude(1.5)
        text(content,font=font,size=size,halign=halign);
    //}
}
