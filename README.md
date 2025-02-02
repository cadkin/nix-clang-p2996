# C++26 p2996 Nix Flake
A simple nix flake that points at my patched nixpkgs to use the p2996 clang fork from [Bloomberg](https://github.com/bloomberg/clang-p2996/pull/24).

## Compiling Code
I'm not going to bother setting up a CMake or anything since this is really just for making the compiler easier to access for Nix folks.

Anyway, you should be able to compile code just by setting the standard to `C++26` and adding `-freflection` once in the develop shell.
```
$ nix develop
$ clang++ -std=c++26 -freflection src/basic-refl.cpp
```
