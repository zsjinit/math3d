local math3d = require "math3d"

local ref1 = math3d.ref()

ref1.m = { s = 10, r = { axis = {1,0,0}, r = math.rad(60) },  t = { 1,2,3 } }
local ref2 = math3d.ref()
ref2.v = math3d.vector(1,2,3,4)
print("ref1", ref1)
print("ref1 value", math3d.tostring(math3d.matrix(ref1)))
print(ref2)
print("ref2 value", math3d.tostring(math3d.vector(ref2)))
ref2.v = math3d.pack("dddd", 1,2,3,4)
print(ref2)
ref2.v = math3d.vector(ref2, 1)
print("ref2", ref2)

for i = 1,4 do
	print("ref1 Line", i, math3d.tostring(ref1[i]))
end

for i = 1,4 do
	print("ref2 index", i, math3d.index(ref2,i))
end

print "===SRT==="
ref1.m = { s = 1, r = { 0, math.rad(60), 0 }, t = { 1,2,3} }
print(ref1)
local s,r,t = math3d.srt(ref1)
print("S = ", math3d.tostring(s))
print("R = ", math3d.tostring(r))
print("T = ", math3d.tostring(t))

local function print_srt()
	print("S = ", math3d.tostring(ref1.s))
	print("R = ", math3d.tostring(ref1.r))
	print("T = ", math3d.tostring(ref1.t))
end

print_srt()
ref1.s = 1
print_srt()
ref1.s = { 3,2,1 }
print_srt()

print "===QUAT==="

local q = math3d.quaternion { 0, math.rad(60, 0), 0 }
print(math3d.tostring(q))
local ref3 = math3d.ref()
ref3.m = math3d.quaternion { axis = {1,0,0}, r = math.rad(60) } -- init mat with quat
print(ref3)
ref3.q = ref3	-- convert mat to quat
print(ref3)

print "===FUNC==="
print(ref2)
ref2.v = math3d.add(ref2,ref2,ref2)
print(ref2)
ref2.v = math3d.mul(ref2, 2.5)
print("length", ref2, "=", math3d.length(ref2))
print("floor", ref2, "=", math3d.tostring(math3d.floor(ref2)))
print("dot", ref2, ref2, "=", math3d.dot(ref2, ref2))
print("cross", ref2, ref2, "=", math3d.tostring(math3d.cross(ref2, ref2)))
local point = math3d.vector(1, 2, 3, 1)
print("transformH", ref1, point, "=", math3d.tostring(math3d.transformH(ref1, point)))
print("normalize", ref2, "=", math3d.tostring(math3d.normalize(ref2)))
print("normalize", ref3, "=", math3d.tostring(math3d.normalize(ref3)))
print("transpose", ref1, "=", math3d.tostring(math3d.transpose(ref1)))
print("inverse", ref1, "=", math3d.tostring(math3d.inverse(ref1)))
print("inverse", ref2, "=", math3d.tostring(math3d.inverse(ref2)))
print("inverse", ref3, "=", math3d.tostring(math3d.inverse(ref3)))
print("reciprocal", ref2, "=", math3d.tostring(math3d.reciprocal(ref2)))

print "===MULADD==="
do
	local v1, v2 = math3d.vector(1, 2, 3, 0), math3d.vector(1, 0, 0, 0)
	local p = math3d.vector(4, 1, 0, 1)
	local r = math3d.muladd(v1, v2, p)
	print("muladd:", math3d.tostring(v1), math3d.tostring(v2), math3d.tostring(p), "=", math3d.tostring(r))
end

print "===VIEW&PROJECTION MATRIX==="
do
	local eyepos = math3d.vector{0, 5, -10}
	local at = math3d.vector {0, 0, 0}
	local direction = math3d.normalize(math3d.vector {1, 1, 1})
	local updir = math3d.vector {0, 1, 0}

	local mat1 = math3d.lookat(eyepos, at, updir)
	local mat2 = math3d.lookto(eyepos, direction, updir)

	print("lookat matrix:", math3d.tostring(mat1), "eyepos:", math3d.tostring(eyepos), "at:", math3d.tostring(at))

	print("lookto matrix:", math3d.tostring(mat2), "eyepos:", math3d.tostring(eyepos), "direction:", math3d.tostring(direction))

	local frustum = {
		l=-1, r=1,
		t=-1, b=1,
		n=0.1, f=100
	}

	local perspective_mat = math3d.projmat(frustum)

	local frustum_ortho = {
		l=-1, r=1,
		t=-1, b=1,
		n=0.1, f=100,
		ortho = true,
	}
	local ortho_mat = math3d.projmat(frustum_ortho)

	print("perspective matrix:", math3d.tostring(perspective_mat))
	print("ortho matrix:", math3d.tostring(ortho_mat))
end

print "===ROTATE VECTOR==="
do
	local v = math3d.vector{1, 2, 1}
	local q = math3d.quaternion {axis=math3d.vector{0, 1, 0}, r=math.pi * 0.5}
	local vv = math3d.transform(q, v, 0)
	print("rotate vector with quaternion", math3d.tostring(v), "=", math3d.tostring(vv))

	local mat = math3d.matrix {s=1, r=q, t=math3d.vector{0, 0, 0, 1}}
	local vv2 = math3d.transform(mat, v, 0)
	print("transform vector with matrix", math3d.tostring(v), "=", math3d.tostring(vv2))

	local p = math3d.vector{1, 2, 1, 1}
	local mat2 = math3d.matrix {s=1, r=q, t=math3d.vector{0, 0, 5, 1}}
	local r_p = math3d.transform(mat2, p, nil)
	print("transform point with matrix", math3d.tostring(p), "=", math3d.tostring(r_p))
end

print "===construct coordinate from forward vector==="
do
	local forward = math3d.normalize(math3d.vector {1, 1, 1})
	local right, up = math3d.base_axes(forward)
	print("forward:", math3d.tostring(forward), "right:", math3d.tostring(right), "up:", math3d.tostring(up))
end

print "===PROJ===="
local projmat = math3d.projmat {fov=90, aspect=1, n=1, f=1000}
print("PROJ", math3d.tostring(projmat))

print "===ADAPTER==="
local adapter = require "math3d.adapter"
local testfunc = require "math3d.adapter.test"

local vector = adapter.vector(testfunc.vector, 1)	-- convert arguments to vector pointer from 1
local matrix1 = adapter.matrix(testfunc.matrix1, 1, 1)	-- convert 1 mat
local matrix2 = adapter.matrix(testfunc.matrix2, 1, 2)	-- convert 2 mat
local matrix = adapter.matrix(testfunc.matrix2, 1)	-- convert all mat
local var = adapter.variant(testfunc.vector, testfunc.matrix1, 1)
local format = adapter.format(testfunc.variant, testfunc.format, 2)
local mvq = adapter.getter(testfunc.getmvq, "mvq")	-- getmvq will return matrix, vector, quat
local matrix2_v = adapter.format(testfunc.matrix2, "mm", 1)
local retvec = adapter.output_vector(testfunc.retvec, 1)
print(vector(ref2, math3d.vector{1,2,3}))
print(matrix1(ref1))
print(matrix2(ref1,ref1))
print(matrix2_v(ref1,ref1))
print(matrix(ref1,ref1))
print(var(ref1))
print(var(ref2))
print(format("mv", ref1, ref2))
local m,v, q = mvq()
print(math3d.tostring(m), math3d.tostring(v), math3d.tostring(q))

local v1,v2 =retvec()
print(math3d.tostring(v1), math3d.tostring(v2))

