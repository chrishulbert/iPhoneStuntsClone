#define MAP_WIDTH  30
#define MAP_HEIGHT 30
#define MAP_ORIGIN_X -15 // Coordinates for the top left of the map (-map_width/2)
#define MAP_ORIGIN_Y 15

enum tiles {
    tileGroundLow = 1,
    tileGroundHigh,
    tileGroundHorizontalLowToHigh, // Going from low at top to high at bottom
    tileGroundHorizontalHighToLow, // Going from high at top to low at bottom
    tileGroundVerticalLowToHigh, // Low on left, high on right 
    tileGroundVerticalHighToLow,
    tileUncertainCorner, // For corners that haven't been fixed yet whilst loading
    tileCornerLowTL,
    tileCornerLowTR,
    tileCornerLowBL,
    tileCornerLowBR,
    tileCornerHighTL,
    tileCornerHighTR,
    tileCornerHighBL,
    tileCornerHighBR,
};

// Different corner types:
// Low corners - where 3 tile corners are low
// Top left, top right, bottom left, bottom right:
// --- ---
// --~ ~--
// -~+ +~-
// 
// -~+ +~-
// --~ ~--
// --- ---
// High corners - where 3 tile corners are high
// Top left, top right, bottom left, bottom right:
// +++ +++
// ++~ ~++
// +~- -~+
//
// +~- -~+
// ++~ ~++
// +++ +++
