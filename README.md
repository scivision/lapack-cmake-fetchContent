# Netlib LAPACK

![ci_linux](https://github.com/scivision/lapack/workflows/ci_linux/badge.svg)
![ci_macos](https://github.com/scivision/lapack/workflows/ci_macos/badge.svg)
![ci_windows](https://github.com/scivision/lapack/workflows/ci_windows/badge.svg)

This repo intends to mirror the latest Netlib Lapack release, with enhanced modern CMake for easier reuse in CMake projects, while building more reliably and much more quickly than the legacy CMake Lapack scripts.

The reason this repo isn't forked is because:

* we work only with Netlib release unmodified source code. If we intend to upgrade Lapack source code, we'd do that through a typical fork and pull request on another repo
* the purpose here is to make a new, modern, clean CMake implementation like the Meson implementation we integrated into Lapack. This can't be done without overwriting the original CMake scripts, which is not conducive to a live Git fork.
