content = "Rafal";
font="Source Sans Pro:style=Bold";
size=5;
halign="center";

difference(){
    rotate([270,0,90])
        import("protoswitchboard_cover_1.stl");

    // The two labels
    translate([-28,-45,8.3])
    {
        drawLabel();
        translate([0,85,0])
        rotate([0,0,180])
        drawLabel();
    }
}

module drawLabel()
{
    union(){
    translate([0,0,0.3])
    linear_extrude(0.5)
        offset(0.5)
            text(content,font=font,size=size,halign=halign);

    linear_extrude(1)
        text(content,font=font,size=size,halign=halign);
    }
}
