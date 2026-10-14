class_name Iso
extends RefCounted

const TILE_W := 64
const TILE_H := 32

static func tile_to_screen(tx: int, ty: int) -> Vector2:
return Vector2((tx - ty) * TILE_W * 0.5, (tx + ty) * TILE_H * 0.5)

static func screen_to_tile(pos: Vector2) -> Vector2i:
var x := pos.x / (TILE_W * 0.5)
var y := pos.y / (TILE_H * 0.5)
var tx := int(round((y + x) * 0.5))
var ty := int(round((y - x) * 0.5))
return Vector2i(tx, ty)
