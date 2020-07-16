from setuptools import setup


setup(
    name="vax-solver",
    version="0.0.1",
    description="Solve the VAX CTF",
    packages=[
        "vax_solver",
    ],
    install_requires=[
        "pwntools"
    ],
)
