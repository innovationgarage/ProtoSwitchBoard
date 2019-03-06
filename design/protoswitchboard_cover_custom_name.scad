content = "THELABEL";

rotate([270,0,90])
    import("protoswitchboard_cover_1.stl");

// The two labels
translate([-28,-45,8.8])
{
drawLabel();
translate([0,85,0])
rotate([0,0,180])
drawLabel();
}

module drawLabel()
{
    linear_extrude(1)
        text(content,font="Source Sans Pro:style=Bold" ,size=5,halign="center");
}