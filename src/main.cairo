%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_not_zero

@storage_var
func grid(x : felt, y : felt) -> (content : felt):
end

@storage_var
func turn() -> (res : felt):
end

@storage_var
func winner() -> (res : felt):
end

@storage_var
func finish() -> (res : felt):
end

@view
func is_finish{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (content : felt):
    let (content) = finish.read()
    return (content)
end

@view
func get_content{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    x : felt, y : felt
) -> (content : felt):
    let (content) = grid.read(x, y)
    return (content)
end

func is_invalid_pos{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    x : felt, y : felt
) -> (res : felt):
    let tmp_x = (x - 0) * (x - 1) * (x - 2)
    let tmp_y = (y - 0) * (y - 1) * (y - 2)
    let (tmp) = is_not_zero(tmp_x + tmp_y)
    return (tmp)
end

@external
func place_cross{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    x : felt, y : felt
) -> ():
    let (tmp) = finish.read()
    assert tmp = 0
    let (tmp) = is_invalid_pos(x, y)
    assert tmp = 0
    let (tmp) = turn.read()
    assert tmp = 0
    turn.write(1)
    grid.write(x, y, 1)

    return ()
end

@external
func place_circle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    x : felt, y : felt
) -> ():
    let (tmp) = finish.read()
    assert tmp = 0
    let (tmp) = is_invalid_pos(x, y)
    assert tmp = 0
    let (tmp) = turn.read()
    assert tmp = 1
    turn.write(0)
    grid.write(x, y, 2)

    return ()
end