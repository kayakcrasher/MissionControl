class_name Iso
extends RefCounted

const TILE_W := 64
const TILE_H := 32
const HALF_W := TILE_W * 0.5
const HALF_H := TILE_H * 0.5

static func tile_to_screen(tx: int, ty: int) -> Vector2:
return Vector2((tx - ty) * HALF_W, (tx + ty) * HALF_H)

static func screen_to_tile(pos: Vector2) -> Vector2i:
var x := pos.x / HALF_W
var y := pos.y / HALF_H
return Vector2i(int(round((y + x) * 0.5)), int(round((y - x) * 0.5)))

static func tile_diamond(center: Vector2) -> PackedVector2Array:
return PackedVector2Array([
center + Vector2(0, -HALF_H),
center + Vector2(HALF_W, 0),
center + Vector2(0, HALF_H),
center + Vector2(-HALF_W, 0),
])
