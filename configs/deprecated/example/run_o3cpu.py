# O3CPU-enabled se.py script based on original, with minimal necessary changes

import argparse
import os
import sys

import m5
from m5.defines import buildEnv
from m5.objects import *
from m5.params import NULL
from m5.util import addToPath, fatal, warn

from gem5.isas import ISA
addToPath("../../")

from common import CacheConfig, CpuConfig, MemConfig, ObjectList, Options, Simulation
from common.Caches import *
from common.cpu2000 import *
from common.FileSystemConfig import config_filesystem
from ruby import Ruby

def get_processes(args):
    multiprocesses = []
    inputs = []
    outputs = []
    errouts = []
    pargs = []

    workloads = args.cmd.split(";")
    if args.input != "":
        inputs = args.input.split(";")
    if args.output != "":
        outputs = args.output.split(";")
    if args.errout != "":
        errouts = args.errout.split(";")
    if args.options != "":
        pargs = args.options.split(";")

    for idx, wrkld in enumerate(workloads):
        process = Process(pid=100 + idx)
        process.executable = wrkld
        process.cwd = os.getcwd()
        process.gid = os.getgid()
        if args.env:
            with open(args.env) as f:
                process.env = [line.rstrip() for line in f]
        if len(pargs) > idx:
            process.cmd = [wrkld] + pargs[idx].split()
        else:
            process.cmd = [wrkld]
        if len(inputs) > idx:
            process.input = inputs[idx]
        if len(outputs) > idx:
            process.output = outputs[idx]
        if len(errouts) > idx:
            process.errout = errouts[idx]
        multiprocesses.append(process)

    if args.smt:
        cpu_type = ObjectList.cpu_list.get(args.cpu_type)
        assert ObjectList.is_o3_cpu(cpu_type), "SMT requires an O3CPU"
        return multiprocesses, len(multiprocesses)
    return multiprocesses, 1

parser = argparse.ArgumentParser()
Options.addCommonOptions(parser)
Options.addSEOptions(parser)
if "--ruby" in sys.argv:
    Ruby.define_options(parser)
args = parser.parse_args()

multiprocesses, numThreads = get_processes(args)
(CPUClass, test_mem_mode, FutureClass) = Simulation.setCPUClass(args)
CPUClass.numThreads = numThreads

if args.smt and args.num_cpus > 1:
    fatal("You cannot use SMT with multiple CPUs!")

np = args.num_cpus
mp0_path = multiprocesses[0].executable

system = System(
    cpu=[CPUClass(cpu_id=i) for i in range(np)],
    mem_mode='timing',
    mem_ranges=[AddrRange(args.mem_size)],
    cache_line_size=args.cacheline_size,
)

if numThreads > 1:
    system.multi_thread = True

system.voltage_domain = VoltageDomain(voltage=args.sys_voltage)
system.clk_domain = SrcClockDomain(clock=args.sys_clock, voltage_domain=system.voltage_domain)
system.cpu_voltage_domain = VoltageDomain()
system.cpu_clk_domain = SrcClockDomain(clock=args.cpu_clock, voltage_domain=system.cpu_voltage_domain)

for cpu in system.cpu:
    cpu.clk_domain = system.cpu_clk_domain

if ObjectList.is_kvm_cpu(CPUClass):
    fatal("KvmCPU not supported in RISC-V SE mode")

for i in range(np):
    if args.smt:
        system.cpu[i].workload = multiprocesses
    elif len(multiprocesses) == 1:
        system.cpu[i].workload = multiprocesses[0]
    else:
        system.cpu[i].workload = multiprocesses[i]
    system.cpu[i].createThreads()

if args.ruby:
    Ruby.create_system(args, False, system)
    system.ruby.clk_domain = SrcClockDomain(clock=args.ruby_clock, voltage_domain=system.voltage_domain)
    for i in range(np):
        ruby_port = system.ruby._cpu_ports[i]
        system.cpu[i].createInterruptController()
        ruby_port.connectCpuPorts(system.cpu[i])
else:
    MemClass = Simulation.setMemClass(args)
    system.membus = SystemXBar()
    system.system_port = system.membus.cpu_side_ports
    CacheConfig.config_cache(args, system)
    MemConfig.config_mem(args, system)
    config_filesystem(system, args)

system.workload = SEWorkload.init_compatible(mp0_path)
if args.wait_gdb:
    system.workload.wait_for_remote_gdb = True

root = Root(full_system=False, system=system)
Simulation.run(args, root, system, FutureClass)
