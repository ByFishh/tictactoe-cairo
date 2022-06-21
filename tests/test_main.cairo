%lang starknet
from src.main import get_content, place_cross
from starkware.cairo.common.cairo_builtins import HashBuiltin

@view
func test_get_content{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    let (result_before) = get_content(0, 0)
    assert result_before = 0
    return ()
end

@view
func test_good_placement{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    place_cross(2, 2)
    return ()
end