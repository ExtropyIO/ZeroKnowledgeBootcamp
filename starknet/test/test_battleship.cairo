%lang starknet
from exercises.contracts.battleship.battleship import (
    game_counter,
    set_up_game,
    check_caller,
    add_squares,
    load_hashes,
    grid,
    Square,
    Game,
    Player,
    bombard,
    games,
    check_hit,
)
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.hash_state import hash_init, hash_update, hash_update_single
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_not_zero, assert_not_equal

const Player_1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95;
const Player_2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;
const Player_3 = 0x238758752376523765276357623576253762537625376708ae8de3d07f1bb56b;

@external
func hash_numb{pedersen_ptr: HashBuiltin*}(numb: felt) -> (hash: felt) {
    alloc_locals;

    let (local array: felt*) = alloc();
    assert array[0] = numb;
    assert array[1] = 1;

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(hash_state_ptr, array, 2);

    return (hash_state_ptr.current_hash,);
}

@external
func test_structs{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // # Creates a square
    let new_square = Square(square_commit=11222, square_reveal=2222, shot=1);

    // # Creates a player
    let new_player = Player(2, 3, 4);

    // # Creates a game
    let new_game = Game(
        player1=new_player, player2=new_player, next_player=324, last_move=(2, 2), winner=999
    );

    return ();
}

@external
func test_set_up_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // # Get counter at the start
    let (game_start) = game_counter.read();

    // # Assert initialised to zero
    assert 0 = game_start;

    // # Set-up a new game
    set_up_game(Player_1, Player_2);

    // # Get value of the new counter
    let (game_after_sub) = game_counter.read();

    // # Assert game counter incremented
    assert game_start + 1 = game_after_sub;

    // # Retrieve game
    let (game) = games.read(0);

    // # Assert correct players loaded
    assert Player_1 = game.player1.address;
    assert Player_2 = game.player2.address;

    // # Assert other fields set to zero
    assert game.winner = 0;
    assert game.next_player = 0;

    return ();
}

@external
func test_check_caller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // # Creates a player
    let new_player1 = Player(Player_1, 0, 0);
    let new_player2 = Player(Player_2, 0, 0);
    let new_player3 = Player(Player_3, 0, 0);

    // # Creates a game
    let new_game = Game(
        player1=new_player1, player2=new_player2, next_player=324, last_move=(2, 2), winner=0
    );

    // # Returns true when called with Player_1
    let (valid) = check_caller(Player_1, new_game);
    assert 1 = valid;

    // # Returns true when called with Player_2
    let (valid) = check_caller(Player_2, new_game);
    assert 1 = valid;

    // # Returns false when called with Player_3
    let (valid) = check_caller(Player_3, new_game);
    assert 0 = valid;

    return ();
}

@external
func test_check_hit{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    // # Hash a number
    let (hashed) = hash_numb(666);  // # Even, missed
    let (hit) = check_hit(hashed, 666);
    assert 0 = hit;

    let (hashed) = hash_numb(1);  // # Odd, hit
    let (hit) = check_hit(hashed, 1);
    assert 1 = hit;

    let (hashed) = hash_numb(22222222222222);  // # Even, missed
    let (hit) = check_hit(hashed, 22222222222222);
    assert 0 = hit;

    let (hashed) = hash_numb(12876349361287319);  // # Odd, hit
    let (hit) = check_hit(hashed, 12876349361287319);
    assert 1 = hit;

    return ();
}

@external
func test_add_squares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // # Set-up a game
    set_up_game(Player_1, Player_2);

    let (local array: felt*) = alloc();
    assert array[0] = 0;
    assert array[1] = 1;
    assert array[2] = 2;
    assert array[3] = 3;
    assert array[4] = 4;
    assert array[5] = 5;
    assert array[6] = 6;
    assert array[7] = 7;
    assert array[8] = 8;
    assert array[9] = 9;
    assert array[10] = 10;
    assert array[11] = 11;
    assert array[12] = 12;
    assert array[13] = 13;
    assert array[14] = 14;
    assert array[15] = 15;
    assert array[16] = 16;
    assert array[17] = 17;
    assert array[18] = 18;

    // # Reverts if player3 tries laoding anything
    %{ stop_prank_callable = start_prank(ids.Player_3) %}
    %{ expect_revert() %}
    add_squares(0, 0, 18, array, Player_1, 0, 0);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.Player_1) %}
    add_squares(0, 0, 18, array, Player_1, 0, 0);
    %{ stop_prank_callable() %}

    // # Assert x:0, y:0 = 1
    let (s) = grid.read(0, Player_1, 0, 0);
    assert s.square_commit = 0;

    // # Assert x:1, y:1 = 9
    let (s) = grid.read(0, Player_1, 1, 1);
    assert s.square_commit = 6;

    // # Assert x:1, y:2 = 17
    let (s) = grid.read(0, Player_1, 1, 2);
    assert s.square_commit = 11;

    // # Assert x:4, y:1 = 14
    let (s) = grid.read(0, Player_1, 4, 1);
    assert s.square_commit = 9;

    return ();
}

// # Test fire at move 0

@external
func test_bombard_move1{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    // # Set-up a game
    set_up_game(player1=Player_1, player2=Player_2);

    let (local array: felt*) = alloc();
    assert array[0] = 0;
    assert array[1] = 1;
    assert array[2] = 2;

    load_hashes(idx=0, game_idx=0, hashes_len=3, hashes=array, player=Player_1, x=0, y=0);

    // # State before being shot
    let (s1) = grid.read(0, Player_1, 0, 0);
    local state_before = s1.shot;

    // # Call as player1
    %{ stop_prank_callable = start_prank(ids.Player_1) %}
    bombard(0, 0, 0, 0);
    %{ stop_prank_callable() %}

    // # State after being shot
    let (s2) = grid.read(0, Player_1, 0, 0);
    local state_after = s2.shot;

    // # State at field (0,0) 0 before being shot and 1 after being shot
    assert 0 = state_before;
    assert 1 = state_after;

    return ();
}

@external
func test_bombard_move2{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    // # Set-up a game
    set_up_game(player1=Player_1, player2=Player_2);

    // # Hash a number
    let (hashed_1) = hash_numb(666);
    let (hashed_2) = hash_numb(3243241);
    let (hashed_3) = hash_numb(6632426);
    let (hashed_4) = hash_numb(32320);

    %{
        from starkware.cairo.common.hash_state import compute_hash_on_elements
        hash = compute_hash_on_elements([666])
        print(f"hash python: ", hash)
        print(f"hash cairo: ", ids.hashed_1)
    %}

    let (local array: felt*) = alloc();
    assert array[0] = hashed_1;
    assert array[1] = hashed_2;
    assert array[2] = hashed_3;
    assert array[3] = hashed_4;

    // # Load hashes as player 1
    load_hashes(idx=0, game_idx=0, hashes_len=4, hashes=array, player=Player_1, x=0, y=0);

    // # Load hashes as player 2
    load_hashes(idx=0, game_idx=0, hashes_len=4, hashes=array, player=Player_2, x=0, y=0);

    // # Start move 1 as player1
    %{ stop_prank_callable = start_prank(ids.Player_1) %}
    bombard(0, 0, 0, 0);
    %{ stop_prank_callable() %}

    // # Reverts if player1 tries playing again
    %{ expect_revert() %}
    bombard(0, 4, 0, 0);
    %{ stop_prank_callable() %}

    // # Reverts with wrong hash
    %{ stop_prank_callable = start_prank(ids.Player_2) %}
    %{ expect_revert() %}
    bombard(0, 1, 0, 664);
    %{ stop_prank_callable() %}

    // # Move 2 as player2
    %{ stop_prank_callable = start_prank(ids.Player_2) %}
    bombard(0, 1, 0, 666);
    %{ stop_prank_callable() %}

    // # Move 3 as player1
    %{ stop_prank_callable = start_prank(ids.Player_1) %}
    bombard(0, 2, 0, 3243241);
    %{ stop_prank_callable() %}

    // # Retrieve scores
    let (game) = games.read(0);

    // # Assert player 1 has 0
    assert 0 = game.player1.address;

    // # Assert player 2 has 1
    assert 1 = game.player2.address;

    return ();
}
