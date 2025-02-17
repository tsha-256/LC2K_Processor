module parking #(parameter SPOTS=64, ENTRY_GATES=3) (
    input                                       reset,
    input                                       clock,
    input  logic [ENTRY_GATES-1:0]              car_incoming,
    input  logic [SPOTS-1:0]                    car_exiting_spots, 

    output logic [ENTRY_GATES-1:0][SPOTS-1:0]   car_assigned_spot
);

    // Represents the current status of the parking lot.
    // A '1' in a bit position indicates that the corresponding spot is free,
    // while a '0' indicates that the spot is occupied.
    logic [SPOTS-1:0] parking_lot;

    // Bit vector used to mark spots that will be filled (occupied) in the next cycle.
    // For example, if the 1st and 2nd spots are to be filled in the next cycle, then
    // fill_spot[1] and fill_spot[2] should be 1 and all other bits should be 0.
    logic [SPOTS-1:0] fill_spot;
    
    // 2D bus output from the priority selector (gnt_bus) indicating
    // which spots are granted to incoming cars for each entry lane.
    logic [ENTRY_GATES-1:0][SPOTS-1:0] lot_gnt_bus;

    // 2D bus output from the priority selector (gnt_bus) indicating
    // which spots are granted to incoming cars for each entry lane.
    logic [ENTRY_GATES-1:0][ENTRY_GATES-1:0] incoming_gnt_bus;
    

    // Instantiation of the priority selector (psel_gen), which grants access
    // to a parking spot based on available free spots
    // Note: solution only requires the gnt_bus output of the priority selector.
    psel_gen #(
         .WIDTH(SPOTS),
         .REQS(ENTRY_GATES)
    ) lot_psel (
         .req(parking_lot),
         .gnt_bus(lot_gnt_bus)
    );


    // Instantiation of the priority selector (psel_gen), which picks out entry
    // gates with an incoming car
    // Note: solution only requires the gnt_bus output of the priority selector.
    psel_gen #(
         .WIDTH(ENTRY_GATES),
         .REQS(ENTRY_GATES)
    ) incoming_psel (
         .req(car_incoming),
         .gnt_bus(incoming_gnt_bus)
    );



    // P1 TODO: Combinational logic for car_assigned_spot
    always_comb begin
        car_assigned_spot = '0;
        for(int i = 0; i < ENTRY_GATES; i++) begin
            car_assigned_spot[i] = lot_gnt_bus[i] & {SPOTS{car_incoming[i]}};
        end
    end

    // P1 TODO: Combinational logic for fill_spot
    always_comb begin
        fill_spot = '0;
        for (int i = 0; i < ENTRY_GATES; i++) begin
            fill_spot |= (lot_gnt_bus[i] & {SPOTS{car_incoming[i]}};
        end
    end


    always_ff @(posedge clock) begin
        if (reset) begin  // On reset, mark all spots as free (1)
            parking_lot <= '1;
        end else begin
            // P1 TODO: Update parking lot using the current state of parking lot
            // and the bit vectors fill_spot and car_exiting_spots
            parking_lot <= parking_lot & ~fill_spot | car_exiting_spots;
            
        end
    end

endmodule