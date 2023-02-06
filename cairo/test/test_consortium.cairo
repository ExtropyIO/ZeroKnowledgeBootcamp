%lang starknet
from exercises.contracts.consortium.consortium import (
    vote_answer,
    answered,
    proposals_idx,
    add_member,
    add_answer,
    load_selector,
    proposals_answers,
    consortium_idx,
    Consortium,
    consortiums,
    create_consortium,
    proposals_title,
    add_proposal,
    members,
    tally,
)
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash_state import hash_init, hash_update
from starkware.cairo.common.math import assert_not_zero, assert_not_equal
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp
from lib.constants import TRUE, FALSE

const Addr_1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95;
const Addr_2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;
const Addr_3 = 0x238758752376523765276357623576253762537625376708ae8de3d07f1bb56b;
const Addr_4 = 0x2635244324a4624a336a4a2342434b3b3af3ba3f3ab3ad3a3de3ed23de2d53d2;

@external
func test_structs{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    // Creates a square
    let new_square = Consortium(chairperson=11222, proposal_count=2222);
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    create_consortium();
    %{ stop_prank_callable() %}
    return ();
}

@external
func test_create_consortium{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    %{ print("\ntest_create_consortium") %}

    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    create_consortium();
    %{ stop_prank_callable() %}

    // Check counter incremented
    let (con_idx) = consortium_idx.read();
    assert 1 = con_idx;

    // Check that caller set as chairperson
    let (con) = consortiums.read(0);
    assert Addr_1 = con.chairperson;

    // Check that Addr_1 added to members array
    let (mem) = members.read(0, Addr_1);
    assert TRUE = mem.prop;

    %{ print("passed creation test") %}

    return ();
}

@external
func test_add_member{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    create_consortium();
    %{ stop_prank_callable() %}

    // Add Addr_2 to consortium as Addr_1
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_member(0, Addr_2, FALSE, 1, 50);
    %{ stop_prank_callable() %}

    // Check that Addr_2 added to members array with right parameters
    let (mem) = members.read(0, Addr_2);
    %{ print(f"\nmem.prop: {ids.mem.prop} \n") %}
    %{ print(f"\nmem.votes: {ids.mem.votes} \n") %}

    assert FALSE = mem.prop; // member can not submit proposals
    assert TRUE = mem.ans;  // member can submit answers to proposals
    assert 50 = mem.votes;

    // Reverts if Addr_2 tries adding member
    %{ stop_prank_callable = start_prank(ids.Addr_2) %}
    %{ expect_revert() %}
    add_member(0, Addr_2, 0, 0, 50);
    %{ stop_prank_callable() %}

    return ();
}

@external
func test_add_proposal{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    create_consortium();
    %{ stop_prank_callable() %}

    // Check proposal counter set to zero
    let (prop_idx) = proposals_idx.read(0);
    assert 0 = prop_idx;

    let (local title: felt*) = alloc();
    assert title[0] = 'What is the best fruit?';

    let (local link: felt*) = alloc();

    let (local answers: felt*) = alloc();
    assert answers[0] = 'Blueberry';
    assert answers[1] = 'Mango';
    assert answers[2] = 'Avocado';

    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_proposal(0, 1, title, 0, link, 3, answers, 1, 0);
    %{ stop_prank_callable() %}

    // Check title stored correctly
    let (t0) = proposals_title.read(0, 0, 0);
    assert 'What is the best fruit?' = t0;

    // Check correct proposal type
    let (proposal) = proposals_idx.read(0);

    // Check answers stored correctly
    let (a0) = proposals_answers.read(0, 0, 0);
    assert 'Blueberry' = a0.text;
    let (a1) = proposals_answers.read(0, 0, 1);
    assert 'Mango' = a1.text;
    let (a2) = proposals_answers.read(0, 0, 2);
    assert 'Avocado' = a2.text;

    // Check proposal counter incremented
    let (prop_idx) = proposals_idx.read(0);
    assert 1 = prop_idx;

    return ();
}

@external
func test_add_answers{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    create_consortium();
    %{ stop_prank_callable() %}

    let (local title: felt*) = alloc();
    assert title[0] = 'What is the best fruit?';

    let (local link: felt*) = alloc();

    let (local answers: felt*) = alloc();
    assert answers[0] = 'Blueberry';
    assert answers[1] = 'Mango';
    assert answers[2] = 'Avocado';

    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_proposal(0, 1, title, 0, link, 3, answers, 1, 0);
    %{ stop_prank_callable() %}

    let (local answer_set_2: felt*) = alloc();
    assert answer_set_2[0] = 'Jackfruit';

    // Assert not answered yet
    let (ans) = answered.read(0, 0, Addr_1);
    assert FALSE = ans;

    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_answer(0, 0, 1, answer_set_2);
    %{ stop_prank_callable() %}

    // Assert member has provided an answered
    let (ans) = answered.read(0, 0, Addr_1);
    assert TRUE = ans;

    // Check answers stored correctly
    let (a0) = proposals_answers.read(0, 0, 0);
    assert 'Blueberry' = a0.text;
    let (a1) = proposals_answers.read(0, 0, 1);
    assert 'Mango' = a1.text;
    let (a2) = proposals_answers.read(0, 0, 2);
    assert 'Avocado' = a2.text;
    let (a3) = proposals_answers.read(0, 0, 3);
    assert 'Jackfruit' = a3.text;

    return ();
}

@external
func test_vote_answer{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    // Create a consortium
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    create_consortium();
    %{ stop_prank_callable() %}

    // Add member 2 with 50 votes
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_member(0, Addr_2, 0, 1, 50);
    %{ stop_prank_callable() %}

    let (local title: felt*) = alloc();
    assert title[0] = 'What is the best fruit?';

    let (local link: felt*) = alloc();

    let (local answers: felt*) = alloc();
    assert answers[0] = 'Blueberry';
    assert answers[1] = 'Mango';
    assert answers[2] = 'Avocado';

    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_proposal(0, 1, title, 0, link, 3, answers, 1, 0);
    %{ stop_prank_callable() %}

    let (ans_votes) = proposals_answers.read(0, 0, 1);
    assert 0 = ans_votes.votes;

    // Vote as admin
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    vote_answer(0, 0, 1);
    %{ stop_prank_callable() %}

    // Check score update
    let (ans_votes) = proposals_answers.read(0, 0, 1);
    assert 100 = ans_votes.votes;

    // Vote as added person
    %{ stop_prank_callable = start_prank(ids.Addr_2) %}
    vote_answer(0, 0, 1);
    %{ stop_prank_callable() %}

    // Check score update
    let (ans_votes) = proposals_answers.read(0, 0, 1);
    assert 150 = ans_votes.votes;

    // Rejects if voted already
    %{ stop_prank_callable = start_prank(ids.Addr_2) %}
    %{ expect_revert() %}
    vote_answer(0, 0, 1);
    %{ stop_prank_callable() %}

    return ();
}

@external
func test_tally{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    // Create a consortium
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    create_consortium();
    %{ stop_prank_callable() %}

    // Add member 2 with 50 votes
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_member(0, Addr_2, FALSE, 1, 50);
    %{ stop_prank_callable() %}

    // Add member 3 with 75 votes
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_member(0, Addr_3, 0, 1, 66);
    %{ stop_prank_callable() %}

    let (local title: felt*) = alloc();
    let (local link: felt*) = alloc();
    let (local answers: felt*) = alloc();

    assert title[0] = 'What is the best fruit?';    
    assert answers[0] = 'Blueberry';
    assert answers[1] = 'Mango';
    assert answers[2] = 'Avocado';

    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    add_proposal(0, 1, title, 0, link, 3, answers, 1, 0);
    %{ stop_prank_callable() %}

    // Vote as admin with 100 votes for 0
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    vote_answer(0, 0, 0);
    %{ stop_prank_callable() %}

    // Check score update
    let (ans_votes) = proposals_answers.read(0, 0, 0);
    assert 100 = ans_votes.votes;

    // Vote as Addr 3 with 66 votes for 2
    %{ stop_prank_callable = start_prank(ids.Addr_3) %}
    vote_answer(0, 0, 2);
    %{ stop_prank_callable() %}

    // Vote as Addr 2 with 50 votes for 2
    %{ stop_prank_callable = start_prank(ids.Addr_2) %}
    vote_answer(0, 0, 2);
    %{ stop_prank_callable() %}

    // Swap caller and time
    %{ stop_prank_callable = start_prank(ids.Addr_1) %}
    %{ stop_warp = warp(321) %}
    let (ts) = get_block_timestamp();
    let (winner) = tally(0, 0);
    assert 2 = winner;
    %{ stop_warp(), stop_prank_callable() %}

    // read state
    let (ans0) = proposals_answers.read(0, 0, 0);
    assert 100 = ans0.votes;
    let (ans1) = proposals_answers.read(0, 0, 1);
    assert 0 = ans1.votes;
    let (ans2) = proposals_answers.read(0, 0, 2);
    assert 116 = ans2.votes;   
     
    return ();
}
