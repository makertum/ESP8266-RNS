pcb_dim=[22,16,1];
shield_dim=[15.2,12.2,2.3];
shield_pos=[5.5,(pcb_dim[1]-shield_dim[1])/2,pcb_dim[2]];

pin_drill_dia=0.5;

connectors_rm=2;
connectors_margin=[6.4,0.05-pin_drill_dia/2];
connectors_count=16;
connectors_row_length=(connectors_count/2-1)*connectors_rm;


overlap=0.1;

breadboard_rm=2.54;
breadboard_row_dist=9*breadboard_rm;
breadboard_row_length=(connectors_count/2-1)*breadboard_rm;
breadboard_margin=[connectors_margin[0]-(breadboard_row_length-connectors_row_length)/2,-(breadboard_row_dist-pcb_dim[1])/2,0];

extra_size=breadboard_rm;
bottom_plate_height=1;
block_dim=[breadboard_row_length+extra_size,breadboard_row_dist+extra_size,shield_dim[2]+pcb_dim[2]+bottom_plate_height];
block_pos=[breadboard_margin[0]-extra_size/2,breadboard_margin[1]-extra_size/2,-bottom_plate_height];

eject_helper_dia=block_dim[1]/2;

module socket(){
	difference(){
		block();
		esp_07_pcb_cutout();
		breadboard_channels();
		breadboard_drills();
		esp_07_drills();
	}
}
socket();
//breadboard_drills();
//esp_07_drills();
//esp_07();

module block(){
	difference(){
		translate(block_pos+[extra_size/2,extra_size/2,0])
			minkowski(){
				cube(block_dim-[extra_size,extra_size,overlap]);
				cylinder(r=extra_size/2,h=overlap,$fn=32);
			}
		eject_helper();
	}
	translate(block_pos)
		%cube(block_dim);
}

module eject_helper(){
	hull(){
		translate([block_pos[0]+block_dim[0],block_pos[1]+block_dim[1]/2,block_pos[2]-overlap])
			cylinder(r=eject_helper_dia/2,h=block_dim[2]+2*overlap,$fn=64);
		translate([pcb_dim[0],pcb_dim[1]/2,block_pos[2]-overlap])
			cylinder(r=eject_helper_dia/2,h=block_dim[2]+2*overlap,$fn=64);
	}
}

module esp_07(){
	difference(){
		union(){
			// the pcb
			esp_07_pcb();
			// the shield
			esp_07_shield();
		}
		// the drills
		esp_07_holes();
	}
}

module esp_07_pcb(){
	cube(pcb_dim);
}

module esp_07_pcb_cutout(){
	cube(pcb_dim+[0,0,shield_dim[2]+overlap]);
}

module esp_07_shield(){
	translate(shield_pos+[0,0,-overlap])
		cube(shield_dim+[0,0,overlap]);	
}

module esp_07_holes(){
	for(xn=[0:1:connectors_count/2-1]){
		xpos=connectors_margin[0]+xn*connectors_rm;
		translate([xpos,connectors_margin[1],-overlap])
			cylinder(r=pin_drill_dia/2,h=pcb_dim[2]+2*overlap,$fn=16);
		translate([xpos,connectors_margin[1]+connectors_rm/2,-overlap])
			cylinder(r=pin_drill_dia/2,h=pcb_dim[2]+2*overlap,$fn=16);
		translate([xpos,pcb_dim[1]-connectors_margin[1],-overlap])
			cylinder(r=pin_drill_dia/2,h=pcb_dim[2]+2*overlap,$fn=16);
		translate([xpos,pcb_dim[1]-connectors_margin[1]-connectors_rm/2,-overlap])
			cylinder(r=pin_drill_dia/2,h=pcb_dim[2]+2*overlap,$fn=16);
	}
}

module esp_07_drills(){
	for(xn=[0:1:connectors_count/2-1]){
		xpos=connectors_margin[0]+xn*connectors_rm;
		hull(){
			translate([xpos,connectors_margin[1]+connectors_rm/2,-bottom_plate_height/2])
				cylinder(r=pin_drill_dia/2,h=block_dim[2]-bottom_plate_height/2+overlap,$fn=16);
			translate([xpos,connectors_margin[1],-bottom_plate_height/2])
				cylinder(r=pin_drill_dia/2,h=block_dim[2]-bottom_plate_height/2+overlap,$fn=16);
		}
		hull(){
			translate([xpos,pcb_dim[1]-connectors_margin[1],-bottom_plate_height/2])
				cylinder(r=pin_drill_dia/2,h=block_dim[2]-bottom_plate_height/2+overlap,$fn=16);
			translate([xpos,pcb_dim[1]-connectors_margin[1]-connectors_rm/2,-bottom_plate_height/2])
				cylinder(r=pin_drill_dia/2,h=block_dim[2]-bottom_plate_height/2+overlap,$fn=16);
		}
		translate([xpos,pcb_dim[1]-connectors_margin[1],-bottom_plate_height/2])
			cylinder(r=pin_drill_dia/2,h=block_dim[2]-bottom_plate_height/2+overlap,$fn=16);
	}
}

module breadboard_drills(){
	for(xn=[0:1:connectors_count/2-1]){
		xpos=breadboard_margin[0]+xn*breadboard_rm;
		translate([xpos,breadboard_margin[1],block_pos[2]-overlap])
			cylinder(r=pin_drill_dia/2,h=block_dim[2]+2*overlap,$fn=16);
		translate([xpos,pcb_dim[1]-breadboard_margin[1],block_pos[2]-overlap])
			cylinder(r=pin_drill_dia/2,h=block_dim[2]+2*overlap,$fn=16);
	}
}


module breadboard_channels(){
	for(xn=[0:1:connectors_count/2-1]){
		xposBreadboard=breadboard_margin[0]+xn*breadboard_rm;
		xposConnectors=connectors_margin[0]+xn*connectors_rm;
		hull(){
			translate([xposBreadboard,breadboard_margin[1],block_pos[2]+block_dim[2]-pin_drill_dia])
				cylinder(r=pin_drill_dia/2,h=pin_drill_dia+overlap,$fn=16);
			translate([xposConnectors,connectors_margin[1],block_pos[2]+block_dim[2]-pin_drill_dia])
				cylinder(r=pin_drill_dia/2,h=pin_drill_dia+overlap,$fn=16);
		}
		hull(){
			translate([xposBreadboard,pcb_dim[1]-breadboard_margin[1],block_pos[2]+block_dim[2]-pin_drill_dia])
				cylinder(r=pin_drill_dia/2,h=pin_drill_dia+overlap,$fn=16);
			translate([xposConnectors,pcb_dim[1]-connectors_margin[1],block_pos[2]+block_dim[2]-pin_drill_dia])
				cylinder(r=pin_drill_dia/2,h=pin_drill_dia+overlap,$fn=16);
		}
	}
}