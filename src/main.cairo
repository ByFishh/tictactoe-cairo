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

@storage_var
func count() -> (value):
end

@view
func is_finish{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (content : felt):
    let (content) = finish.read()
    return (content)
end

@view
func get_winner{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (content : felt):
    let (tmp) = winner.read()
    return (tmp)
end

@view
func get_content{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    x : felt, y : felt
) -> (content : felt):
    let (content) = grid.read(x, y)
    return (content)
end

func check_horizontal_line{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    y : felt
) -> (res : felt):
    alloc_locals
    if y == 3:
        return (0)
    end

    local syscall_ptr : felt* = syscall_ptr

    let (tmp_0) = grid.read(0, y)
    let (tmp_1) = grid.read(1, y)
    let (tmp_2) = grid.read(2, y)

    if tmp_0 == 0:
        return (0)
    end

    if tmp_0 == tmp_1:
        if tmp_1 == tmp_2:
            return (1)
        end
    end
    let (tmp) = check_horizontal_line(y + 1)
    return (tmp)
end

func check_vertical_line{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    x : felt
) -> (res : felt):
    alloc_locals

    local syscall_ptr : felt* = syscall_ptr

    let (tmp_0) = grid.read(x, 0)
    let (tmp_1) = grid.read(x, 1)
    let (tmp_2) = grid.read(x, 2)

    if tmp_0 == 0:
        return (0)
    end

    if tmp_0 == tmp_1:
        if tmp_1 == tmp_2:
            return (1)
        end
    end
    let (tmp) = check_horizontal_line(x + 1)
    return (tmp)
end

func check_diag1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (res : felt):
    alloc_locals
    local syscall_ptr : felt* = syscall_ptr

    let (tmp_0) = grid.read(0, 0)
    let (tmp_1) = grid.read(1, 1)
    let (tmp_2) = grid.read(2, 2)

    if tmp_0 == 0:
        return (0)
    end

    if tmp_0 == tmp_1:
        if tmp_1 == tmp_2:
            return (1)
        end
    end
    return (0)
end

func check_diag2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (res : felt):
    alloc_locals
    local syscall_ptr : felt* = syscall_ptr

    let (tmp_0) = grid.read(2, 0)
    let (tmp_1) = grid.read(1, 1)
    let (tmp_2) = grid.read(0, 2)

    if tmp_0 == 0:
        return (0)
    end

    if tmp_0 == tmp_1:
        if tmp_1 == tmp_2:
            return (1)
        end
    end
    return (0)
end

func win_condition{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (res : felt):
    let (tmp) = check_horizontal_line(0)
    if tmp == 1:
        return (1)
    end
    let (tmp) = check_vertical_line(0)
    if tmp == 1:
        return (1)
    end
    let (tmp) = check_diag1()
    if tmp == 1:
        return (1)
    end
    let (tmp) = check_diag2()
    if tmp == 1:
        return (1)
    end
    return (0)
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
func restart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> ():
    let (tmp) = finish.read()
    with_attr error_message(
        "This game is currently running !"):
        assert tmp = 1
    end
    grid.write(0, 0, 0)
    grid.write(0, 1, 0)
    grid.write(0, 2, 0)
    grid.write(1, 0, 0)
    grid.write(1, 1, 0)
    grid.write(1, 2, 0)
    grid.write(2, 0, 0)
    grid.write(2, 1, 0)
    grid.write(2, 2, 0)
    finish.write(0)
    winner.write(0)
    return ()
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

    let (tmp) = win_condition()
    if tmp == 1:
        finish.write(1)
        winner.write(1)
        return ()
    end
    let (tmp) = count.read()
    count.write(tmp + 1)
    if tmp == 9:
        finish.write(1)
        return ()
    end
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

    let (tmp) = win_condition()
    if tmp == 1:
        finish.write(1)
        winner.write(2)
        return ()
    end
    let (tmp) = count.read()
    count.write(tmp + 1)
    if tmp == 9:
        finish.write(1)
        return ()
    end
    return ()
end