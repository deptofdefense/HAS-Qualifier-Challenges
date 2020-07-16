from setuptools import setup


setup(
    name="vax-common",
    version="0.0.1",
    description="Common code for the VAX CTF",
    packages=[
        "vax_common",
    ],
    install_requires=[
        "dataclasses",
        "PyYAML"
    ],
    tests_require=[
        "pytest",
    ]
)
