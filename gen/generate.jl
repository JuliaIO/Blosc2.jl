using Clang.Generators
using Blosc2_jll

cd(@__DIR__)

include_dir = joinpath(Blosc2_jll.artifact_dir, "include") |> normpath

options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()
push!(args, "-I$include_dir  -fparse-all-comments")

headers = [joinpath(include_dir, "blosc2.h")]

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)